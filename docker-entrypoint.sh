#!/usr/bin/env bash
set -ex

local_init() {
  target_gid=$(stat -c "%g" .)
  if [ "$(grep "$target_gid" -c /etc/group)" -eq "0" ]; then
    groupadd -g "$target_gid" localworker
    usermod -a -G localworker worker
  else
    group=$(getent group "$target_gid" | cut -d: -f1)
    usermod -a -G "$group" worker
  fi
  bundle config --global frozen 0
  bundle check || bundle install
}

# init a new application and exit
[ -n "$INIT_APP" ] && rails new --skip-bundle app && exit $?

# environment specific configuration
case $RAILS_ENV in
  development )
    set -x
    local_init
    ;;
  test )
    local_init
    rake db:create db:schema:load --trace
    ;;
  staging|production )
    ;;
  * )
    printf 'Unknown value for RAILS_ENV variable: %s' "${RAILS_ENV:-<none>}"
    printf "Possible values are: development|test|staging|production"
    exit 1
    ;;
esac

# application specific configuration
case $1 in
  puma|rails )
    rake db:migrate --trace
    rake assets:precompile --trace
    ;;
  * )
    exec "$@"
    ;;
esac

exec gosu worker "$@"
