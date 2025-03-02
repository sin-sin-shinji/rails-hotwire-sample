FROM ruby:3.4.2-slim as base

ENV LANG C.UTF-8
ENV APP_ROOT=/app/

RUN apt-get update -qq \
    &&  apt-get install -y --no-install-recommends \
        build-essential \
        default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir $APP_ROOT
WORKDIR $APP_ROOT
