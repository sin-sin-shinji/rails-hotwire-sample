FROM ruby:3.4.2-slim as base

ENV LANG C.UTF-8
ENV APP_ROOT=/app/

RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends \
        build-essential \
        default-mysql-client \
        libmariadb-dev \
        libyaml-dev \
        pkg-config \
        curl \
        wget \
        gnupg \
        ca-certificates \
        libnss3 \
        libatk1.0-0 \
        libatk-bridge2.0-0 \
        libcups2 \
        libxkbcommon0 \
        libgbm1 \
        libasound2 \
        fonts-liberation \
        xdg-utils \
        libxcomposite1 \
        libxdamage1 \
        libxrandr2 \
        libxss1 \
        libgtk-3-0 \
        libdrm2 \
    && rm -rf /var/lib/apt/lists/*

# Node.js(20) + npm のインストール
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs

# yarn のインストール
RUN npm install -g yarn

# Playwright のインストール
RUN npx playwright install --with-deps

RUN mkdir $APP_ROOT
WORKDIR $APP_ROOT
