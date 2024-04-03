FROM python:slim-bookworm
USER root
COPY main.py main.py
COPY requirements.txt requirements.txt


RUN pip install --upgrade pip
RUN pip install -r requirements.txt
ENV PORT=8080
USER 1000
# the --port $PORT is added here so that we can run this on Google Cloud Run
CMD uvicorn main:app --host 0.0.0.0 --port $PORT
