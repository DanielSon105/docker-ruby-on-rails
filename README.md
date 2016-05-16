# Simple Ruby on Rails on Docker

## Installation

- Change application name (`webapp` by default), Ruby and Rails versions in `./bootstrap.sh` if needed, also change it in the following file:

  - **docker-compose.yml**: [line 6](docker-compose.yml#L6) for Ruby version and [line 14](docker-compose.yml#L14) for application name.
  - **Dockerfile**: [line 2](Dockerfile#L2) for Ruby version.
  - **Dockerfile.prod**: [lines 5, 6](Dockerfile.prod#L5-L6), and [line 12](Dockerfile.prod#L12) for application name.

- Build base development image (which only includes Ruby and some useful tools):

  ```sh
  ./bootstrap.sh build dev
  ```

- Bootstrap an application:

  ```sh
  ./bootstrap.sh setup
  ```

- Add required gems to `./webapp/Gemfile` if desired (like `gem 'puma'` to work with default cmd).

- Generate `Gemfile.lock` (required to build Docker image):

  ```sh
  ./bootstrap.sh gemfile
  ```

- Start application inside docker using docker-compose:

  ```sh
  docker-compose up
  ```

- When ready to be shipped, build a production image (this will install all the gems and copy your application into the image):

  ```sh
  ./bootstrap.sh build prod
  ```

## Updating gems

To update gems after changing `Gemfile` content, simply restart application by running:

```sh
# if the app is running in background (e.g. docker-compose up -d app):
docker-compose restart app
# if the app is running in foreground, then CTR+C and start it again:
docker-compose up app
```
