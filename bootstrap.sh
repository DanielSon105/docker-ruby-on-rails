#!/usr/bin/env bash
set -e

# configuration:
app_name='app'

# should fix osx files ownership (?)
case $OSTYPE in
  linux* )
    user_id="$(id -u)"
    group_id="$(id -u)"
    ;;
  darwin* )
    user_id="1000"
    group_id="$(id -u)"
    ;;
  * )
    printf "Unsupported operating system."
    exit 1
    ;;
esac

docker build --tag rails-skeleton:4.2.7.1 .
exec docker run \
  -it \
  --rm \
  --user "$user_id:$group_id" \
  --volume "$PWD":/usr/src/app \
  -e INIT_APP=1 \
  -w /usr/src/app \
  rails-skeleton:4.2.7.1 \
    rails new --skip-bundle $app_name
