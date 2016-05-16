#!/usr/bin/env bash

# configuration:
rails_version='4.2.6'
app_name='webapp'

docker run \
  -it \
  --rm \
  --user "$(id -u):$(id -g)" \
  --volume "$PWD":/usr/src/app \
  -w /usr/src/app \
  rails:$rails_version \
    rails new --skip-bundle $app_name
