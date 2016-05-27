# Simple Ruby on Rails on Docker

## Requirements

- Windows / Mac:

  - [Docker Toolbox](https://www.docker.com/products/docker-toolbox)

    - Some useful `docker-machine` commands to get started (assuming you are using `default` machine, otherwise add machine name at the end):

      ```sh
      # list machines:
      docker-machine ls
      # apply docker-machine configuration  (connect to docker server),
      # this command needs to be executed in every terminal window (session):
      eval $(docker-machine env)
      # get machine ip (to access rails site, database, etc.):
      docker-machine ip
      # start, stop or restart machine
      docker-machine start
      docker-machine stop
      docker-machine restart
      # create another machine
      docker-machine create \
        --driver virtualbox \
        --virtualbox-cpu-count 2 \
        --virtualbox-memory 2048 \
        new-machine
      ```

- Linux:

  - [Docker Engine](https://www.docker.com/products/docker-engine)
  - [Docker Compose](https://www.docker.com/products/docker-compose)

## Installation

- Change application name (`webapp` by default), Ruby and Rails versions in `./bootstrap.sh` if needed, also change it in the following file:

  - **Dockerfile**: [line 2](Dockerfile#L2) for Ruby version.
  - **Dockerfile.prod**: [lines 5, 6](Dockerfile.prod#L5-L6), and [line 12](Dockerfile.prod#L12) for application name.
  - **docker-compose.yml**: [line 14](docker-compose.yml#L14) for application name.

- Bootstrap an application:

  ```sh
  ./bootstrap.sh
  ```

- Add required gems to `./webapp/Gemfile` if desired (like `gem 'puma'` to work with default command).

- Build and start application inside docker using docker-compose (on the first launch it will install all the gems into a shared folder, so it might take a while):

  ```sh
  docker-compose up --build app
  ```

- When ready to be shipped, build a production image (this will install all the gems and copy your application into the image):

  ```sh
  docker build --tag "repo/name:veresion" --file Dockerfile.prod .
  ```

## Updating gems

To update gems after changing `./webapp/Gemfile` content, simply restart application by running:

```sh
# if the app is running in background (e.g. docker-compose up -d app):
docker-compose restart app
# if the app is running in foreground, then CTR+C and start it again:
docker-compose up app
```

## Enabling database

- PostgreSQL:

  1. Uncomment the `db` service inside `docker-compose.yml` file and the `DB_*` environment variables of `app` service.
  2. Stat the database and keep it running in the background:

    ```sh
    docker-compose up -d db
    ```

  3. Add `pg` gem into `./webapp/Gemfile` and remove the `sqlite3` gem:

    ```ruby
    gem 'pg', '0.18.4'
    # gem 'sqlite3'
    ```

  5. Edit `./webapp/config/database.yml` file (the key idea behind this is to use variables, defined in `docker-compose.yml` file to set up a connection):

    ```yaml
    default: &default
      adapter: postgresql
      pool: 5
      timeout: 5000
      host: <%= ENV['DB_HOST'] || 'localhost' %>
      port: <%= ENV['DB_PORT'] || '5432' %>
      database: <%= ENV['DB_NAME'] %>
      username: <%= ENV['DB_USER'] %>
      password: <%= ENV['DB_PASSWORD'] %>

    development:
      <<: *default

    test:
      <<: *default

    production:
      <<: *default
    ```

  6. Update the gems by restarting application (see **Updating gems** section), you now should be connected to `postgresql` database from within your application.

  7. Don't forget to stop the application and database after you finish:

    ```sh
    docker-compose stop
    ```
