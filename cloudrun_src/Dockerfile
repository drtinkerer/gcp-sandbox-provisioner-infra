FROM python:3.12.0

COPY ./app /app
COPY requirements.txt requirements.txt
RUN pip install --upgrade pip
RUN pip install --no-cache-dir --upgrade -r requirements.txt

ENV PORT=8080
ENV AUTHORIZED_DOMAIN_NAMES="cloudpoet.in,gmail.com"
ENV AUTHORIZED_TEAM_FOLDERS="{\"Team-3\":\"folders/550157719134\",\"Team-4\":\"folders/1005335406543\",\"Team-Data\":\"folders/118001772766\",\"Team-DevOps\":\"folders/330608683756\"}"
CMD uvicorn app.main:app --host 0.0.0.0 --port $PORT