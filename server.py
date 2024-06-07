# enrico simonetti - naonis.tech
# test echo server on port 8080 or whatever is passed to the env variable

from http.server import BaseHTTPRequestHandler, HTTPServer
import logging
import os

class EchoHandler(BaseHTTPRequestHandler):
    def _set_response(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()

    def do_GET(self):
        logging.info("GET request,\nPath: %s\nHeaders:\n%s\n",
                     str(self.path), str(self.headers))
        self._set_response()
        self.wfile.write("GET request for {}".format(self.path).encode("utf-8"))

    def do_POST(self):
        # size of data
        content_length = int(self.headers["Content-Length"])
        # data
        post_data = self.rfile.read(content_length)
        logging.info("POST request,\nPath: %s\nHeaders:\n%s\n\nBody:\n%s\n",
                     str(self.path), str(self.headers), post_data.decode("utf-8"))

        self._set_response()
        self.wfile.write("POST request for {}".format(self.path).encode("utf-8"))

def run(server_class=HTTPServer, handler_class=EchoHandler, port=None):
    logging.basicConfig(level=logging.INFO)
    server_address = ("", port)
    httpd = server_class(server_address, handler_class)
    logging.info("Starting httpd on port %s...\n", str(port))
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    httpd.server_close()
    logging.info("Stopping httpd...\n")

if __name__ == "__main__":
    port = int(os.getenv("ECHO_SERVER_PORT", 8080))
    run(port=port)
