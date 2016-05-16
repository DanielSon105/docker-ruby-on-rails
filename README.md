# Simple Ruby on Rails on Docker

## Installation

- Change Ruby and RoR versions in `./bootstrap.sh` if needed.
- Change application name in `./bootstrap.sh` if needed, also change it in the following files:
  - docker-compose.yml line [11](docker-compose.yml#L11)
  - Dockerfile: lines [49, 50](Dockerfile#L49-L50) and [56](Dockerfile#L56)
- Bootstrap an application:

  ```sh
  ./bootstrap.sh setup
  ```

- Add required gems to `./webapp/Gemfile` if desired.
- Generate `Gemfile.lock` (required to build Docker image):

  ```sh
  ./bootstrap.sh gemfile
  ```

- Build and start application inside docker (using docker-compose):

  ```sh
  docker-compose up --build
  ```

## Updating gems

To update gems after changing `Gemfile` content, simply restart application by running:

```sh
docker-compose restart app
```
