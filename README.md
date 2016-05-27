# Simple Ruby on Rails on Docker

## Requirements

- Windows / Mac:

  - [Docker Toolbox]()

    - Some useful `docker-machine` commands to get started (assuming you are using `default` machine, otherwise add machine name at the end):

      ```sh
      # list machines:
      docker-machine ls
      # apply docker-machine configuration  (connect to docker server):
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

  - [Docker Engine]()
  - [Docker Compose]()

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
