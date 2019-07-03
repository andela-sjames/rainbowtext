FROM python:3.7.2-alpine3.8

ENV PYTHONUNBUFFERED 1

ADD requirements.txt .

RUN apk update
RUN apk add --no-cache --virtual build-dependencies \
    gcc \
    libc-dev \
    libpcre3 \
    libpcre3-dev \
    linux-headers \
    && pip install --no-cache-dir -r requirements.txt \
    && apk del build-dependencies

ADD . /app/
WORKDIR /app

# load project files and set work directory
RUN addgroup -S docker && adduser -S docker -D docker
USER docker

ENTRYPOINT [ "uwsgi", "--ini", "uwsgi.ini" ]
