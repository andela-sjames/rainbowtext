FROM python:3.7.2-alpine3.8

ENV PYTHONUNBUFFERED 1

ADD requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

ADD . /app/
WORKDIR /app

# load project files and set work directory
RUN addgroup -S docker && adduser -S docker -D docker
USER docker

CMD [ "python", "app.py" ]

