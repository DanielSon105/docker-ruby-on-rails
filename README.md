# Simple Ruby on Rails on Docker

## Installation

- Change Ruby and RoR versions in `./bootstrap.sh` if needed, also change it in the following file:

  - **Dockerfile**: line [2](Dockerfile#L2) for Ruby version and line [39](Dockerfile#L39) for RoR version.

- Change application name in `./bootstrap.sh` if needed, also change it in the following files:

  - **docker-compose.yml**: line [11](docker-compose.yml#L11)
  - **Dockerfile**: lines [49, 50](Dockerfile#L49-L50), [56](Dockerfile#L56) and [62](Dockerfile#L62)

- Bootstrap an application:

  ```sh
  ./bootstrap.sh setup
  ```

- Add required gems to `./webapp/Gemfile` if desired.

- Generate `Gemfile.lock` (required to build Docker image):

  ```sh
  ./bootstrap.sh gemfile
  ```

- Build and start application inside docker using docker-compose (it might take a while, since it will re-download all the gems inside the Docker image so in the future we can just ship it as it is):

  ```sh
  docker-compose up --build
  ```

## Updating gems

To update gems after changing `Gemfile` content, simply restart application by running:

```sh
# if the app is running in background (e.g. docker-compose up -d app):
docker-compose restart app
# if the app is running in foreground, then CTR+C and start it again:
docker-compose up app
```
