#  base image
FROM ruby:2.3.1

# set up required group, user and directories
ENV APP_DIR '/usr/src/app'
RUN set -ex \
    && groupadd --gid 118 --system worker \
    && useradd --uid 118 --gid 118 --shell /bin/false --home-dir /nonexistent --system worker \
    && mkdir --parents "$APP_DIR" \
    && chown --recursive worker:worker "$APP_DIR"
WORKDIR "$APP_DIR"

# install required packages
RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        mysql-client \
        nodejs \
        postgresql-client \
        sqlite3 \
    && rm -rf /var/lib/apt/lists/*

# install gosu
ENV GOSU_VERSION '1.9'
ENV GOSU_GPG_KEY 'B42F6819007F00F88E364FD4036A9C25BF357DD4'
RUN set -ex \
    && wget -O /usr/local/bin/gosu \
        "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
    && wget -O /usr/local/bin/gosu.asc \
        "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$GOSU_GPG_KEY" \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true

# install rails
ENV RAILS_VERSION '4.2.6'
RUN set -ex \
    && gem install rails --version "$RAILS_VERSION"

# install puma
ENV PUMA_VERSION '3.4.0'
RUN set -ex \
    && gem install puma --version "$PUMA_VERSION"

# install required gems
COPY ./webapp/Gemfile .
COPY ./webapp/Gemfile.lock .
RUN set -ex \
    && bundle config --global frozen 1 \
    && bundle install

# copy application code
COPY ./webapp .

# expose puma's port
EXPOSE 9292

# entrypoint / default command
ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["puma", "-b", "tcp://0.0.0.0:9292", "--log-requests"]
