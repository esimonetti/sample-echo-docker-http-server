# enrico simonetti - naonis.tech
FROM python:3.9-slim
WORKDIR /app
COPY server.py .
CMD ["python", "server.py"]
