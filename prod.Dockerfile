#  base image
FROM docker-ruby-on-rails-dev

# install required gems
COPY ./webapp/Gemfile .
COPY ./webapp/Gemfile.lock .
RUN set -ex \
    && bundle config --global frozen 1 \
    && bundle install

# copy application code
COPY ./webapp .
