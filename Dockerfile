FROM ruby:latest

ENV APP_DIR=/var/app

WORKDIR ${APP_DIR}
COPY Gemfile* ./
RUN bundle install --system
COPY . .
VOLUME [ "${APP_DIR}" ]
