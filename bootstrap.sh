#!/usr/bin/env bash

# configuration:
ruby_version='2.3.1'
rails_version='4.2.6'
app_name='webapp'

image_name_dev="docker-ruby-on-rails-dev:$ruby_version"
image_name_prod="docker-ruby-on-rails-prod:$ruby_version"

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
      --volume "$PWD/$app_name":/usr/src/app \
      --volume "$PWD/.bundle":/usr/local/bundle \
      -w /usr/src/app \
      ruby:$ruby_version \
        bash -c "bundle check || bundle install"
    ;;
  build )
    case $2 in
      dev )
        docker build --tag $image_name_dev .
        ;;
      prod )
        docker build --tag $image_name_prod --file Dockerfile.prod .
        ;;
      * )
        echo "Usage: $0 build dev|prod"
        ;;
    esac
    ;;
  * )
    echo "Usage: $0 setup|gemfile|build"
    ;;
esac
