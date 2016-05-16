#!/usr/bin/env bash

# configration:
ruby_version='2.3.1'
rails_version='4.2.6'
app_name='webapp'

case $1 in
  setup )
    docker run \
      -it \
      --rm \
      --user "$(id -u):$(id -g)" \
      --volume "$PWD":/usr/src/app \
      -w /usr/src/app \
      rails:$rails_version \
        rails new --skip-bundle $app_name
    ;;
  gemfile )
    docker run \
      --rm \
      --env BUNDLE_PATH='/usr/local/bundle-cache' \
      --volume "$PWD/$app_name":/usr/src/app \
      --volume "$PWD/.bundle":/usr/local/bundle-cache \
      -w /usr/src/app \
      ruby:$ruby_version \
        bash -c "bundle check || bundle install"
    ;;
  * )
    echo "Usage: $0 setup|gemfile"
    ;;
esac
