# Simple Ruby on Rails on Docker

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
