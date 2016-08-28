#  base image
FROM ruby:2.3

# set up required group, user and directory
ENV APP_DIR '/usr/src/app'
RUN set -ex \
    && groupadd --gid 118 --system worker \
    && useradd --uid 118 --gid 118 --shell /bin/false --home-dir /usr/src/app \
        --create-home --system worker
WORKDIR /usr/src/app

# install gosu
ENV GOSU_VERSION '1.9'
ENV GOSU_GPG_KEY 'B42F6819007F00F88E364FD4036A9C25BF357DD4'
ENV GOSU_URL 'https://github.com/tianon/gosu/releases/download'
RUN set -ex \
    && wget -O /usr/local/bin/gosu \
        "$GOSU_URL/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
    && wget -O /usr/local/bin/gosu.asc \
        "$GOSU_URL/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$GOSU_GPG_KEY" \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true

# install required packages
RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        nodejs \
        postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# install rails
ENV RAILS_VERSION '4.2.7.1'
RUN set -ex \
    && gem install rails --version "$RAILS_VERSION"

# expose puma's port
EXPOSE 9292

# entrypoint / default command
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["puma", "-b", "tcp://0.0.0.0:9292", "--log-requests"]
