# Simple Ruby on Rails on Docker

## Installation

- Change application name, Ruby and RoR versions in `./bootstrap.sh` if needed (if you will change application name, edit `Dockerfile`'s lines 49, 60 and 56 too).
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

To update gems after changing `Gemfile` content, simply restart application:

```sh
docker-compose restart app
```
