FROM ruby:2.5.1-alpine

MAINTAINER Evan Ilukhin <evanilukhin@gmail.com>

RUN mkdir /app
WORKDIR /app

RUN apk update && apk add build-base nodejs

COPY Gemfile Gemfile.lock ./
RUN bundle install --binstubs

COPY . .

CMD puma -C config/puma.rb