#!/usr/bin/env bash

check_user_for() {
  owner_user=$(stat -c %u "$1")
  owner_group=$(stat -c %g "$1")
  worker_user=$(id -u worker)
  worker_group=$(id -g worker)
  if [ "$owner_user" -ne "$worker_user" -o "$owner_group" -ne "$worker_group" ]; then
    deluser 'worker'
    groupadd --gid "$owner_group" --system worker
    useradd --uid "$owner_user" --gid "$owner_group" --shell /bin/false \
      --home-dir /nonexistent --system worker
  fi
}

# check if rails_env variable is set, otherwise use development
if [ -z "$RAILS_ENV" ]; then
  printf "Warning!\n  Variable RAILS_ENV is not set!\n  Using: development\n"
  export RAILS_ENV='development'
fi

# environment specific configuration
case $RAILS_ENV in
  development )
    check_user_for .
    bundle config --global frozen 0
    bundle check || bundle install
    ;;
esac

# application specific configuration
case $1 in
  puma|rails )
    rake db:migrate --trace
    rake assets:precompile --trace
    ;;
  bundle )
    exec "$@"
    ;;
esac

chown -R worker:worker .
exec gosu worker "$@"
