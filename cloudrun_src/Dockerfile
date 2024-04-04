FROM python:3.12.0

COPY ./app /app
COPY requirements.txt requirements.txt
RUN pip install --upgrade pip
RUN pip install --no-cache-dir --upgrade -r requirements.txt
ENV PORT=8080
# the --port $PORT is added here so that we can run this on Google Cloud Run
CMD uvicorn app.main:app --host 0.0.0.0 --port $PORT