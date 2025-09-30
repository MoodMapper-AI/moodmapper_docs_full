FROM python:3.11-slim
RUN pip install yt-dlp flask
WORKDIR /app
COPY app.py /app/app.py
EXPOSE 8080
CMD ["python","app.py"]
