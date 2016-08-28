# Simple Ruby on Rails on Docker (with PostgreSQL)

## Requirements

- Windows / Mac:

  - [Docker Toolbox](https://www.docker.com/products/docker-toolbox)

- Linux:

  - [Docker Engine](https://www.docker.com/products/docker-engine)
  - [Docker Compose](https://www.docker.com/products/docker-compose)

## Installation

- Bootstrap an application (this will build a `rails-skeleton:4.2.7.1` image and initialize empty Ruby on Rails application):

  ```sh
  ./bootstrap.sh
  ```

- Add `puma` gem to `./app/Gemfile`:

  ```rb
  gem 'puma', '3.6.0'
  ```

- Add any other gems to `./app/Gemfile` if desired.

- Build and start application inside docker using `docker-compose` (on the first launch all the gems will be installed, so it might take a while, they will be cached for development environment):

  ```sh
  docker-compose up --build app
  ```

- When ready to be shipped, build a production image (this will install all the gems and copy your application into the image itself):

  ```sh
  docker build --tag "repo/name:tag" --file Dockerfile.prod .
  # docker push ...
  ```

## Updating gems

To update gems after changing `./app/Gemfile` content, simply restart application by executing:

```sh
# if the app is running in background (e.g. docker-compose up -d app):
docker-compose restart app
# if the app is running in foreground, then CTR+C and start it again:
docker-compose up app
```

## Adding PostgreSQL database

- Stat the database and keep it running in the background:

  ```sh
  docker-compose up -d db
  ```

- Add `pg` gem into `./app/Gemfile` and remove the `sqlite3` gem:

  ```ruby
  gem 'pg', '0.18.4'
  # gem 'sqlite3'
  ```

- Edit `./app/config/database.yml` file (the key idea behind this is to use variables defined in `docker-compose.yml` file to set up a connection):

  ```yaml
  default: &default
   adapter: postgresql
   pool: 5
   timeout: 5000
   host: <%= ENV['DB_HOST'] || 'localhost' %>
   port: <%= ENV['DB_PORT'] || '5432' %>
   database: <%= ENV['DB_NAME'] || 'rails_db' %>
   username: <%= ENV['DB_USER'] %>
   password: <%= ENV['DB_PASSWORD'] %>

  test:
   <<: *default
   database: <%= ENV['DB_TEST_NAME'] || 'rails_test_db' %> # use separate db for tests

  development:
   <<: *default

  production:
   <<: *default
  ```

- Update the gems by restarting application (see **Updating gems** section), you now should be connected to `postgresql` database from within your application.

- Don't forget to stop the application and database after you finish:

  ```sh
  docker-compose stop
  # to completely remove all containers, volumes and images:
  docker-compose down --rmi local
  ```
