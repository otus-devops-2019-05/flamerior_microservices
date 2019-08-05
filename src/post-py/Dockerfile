FROM python:3.6.0-alpine
WORKDIR /app

ENV POST_DATABASE_HOST post_db
ENV POST_DATABASE posts

COPY requirements.txt /app
RUN apk add --no-cache --virtual deps gcc musl-dev \
    && pip install -r /app/requirements.txt \
    && apk del deps
COPY . /app

ENTRYPOINT ["python3", "post_app.py"]
