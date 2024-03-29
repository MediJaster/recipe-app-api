FROM python:3.11-alpine3.19
LABEL maintaner="medijaster"

ENV PYTHONBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app

WORKDIR /app

EXPOSE 8000

ARG DEV=False

RUN apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps build-base postgresql-dev musl-dev

RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "True" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp

RUN apk del .tmp-build-deps

RUN adduser --disabled-password --no-create-home django

ENV PATH="/py/bin:$PATH"

USER django