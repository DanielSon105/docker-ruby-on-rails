#!/usr/bin/env bash

# configuration:
rails_version='4.2.6'
app_name='webapp'

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

docker run \
  -it \
  --rm \
  --user "$user_id:$group_id" \
  --volume "$PWD":/usr/src/app \
  -w /usr/src/app \
  rails:$rails_version \
    rails new --skip-bundle $app_name
