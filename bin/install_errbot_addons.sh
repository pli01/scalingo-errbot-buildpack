#!/bin/bash
#
# install backends and storage
#

set -euo pipefail

echo "# $(basename $0)"

#err_backend_mattermost_version="tags/2.1.0"
err_backend_mattermost_version="heads/master"
err_backend_mattermost="https://github.com/errbotio/err-backend-mattermost/archive/refs/${err_backend_mattermost_version}.tar.gz"
err_backend_mattermost_dir="err-backend-mattermost"
err_storage_redis_version="heads/master"
err_storage_redis="https://github.com/errbotio/err-storage-redis/archive/refs/${err_storage_redis_version}.tar.gz"
err_storage_redis_dir="err-storage-redis"

mkdir errbackends
( cd errbackends  ;
  mkdir $err_backend_mattermost_dir
  curl -sL $err_backend_mattermost | \
    tar zxvf - --strip-components 1 -C $err_backend_mattermost_dir
)

mkdir errstorage
(
  cd errstorage
  mkdir $err_storage_redis_dir
  curl -sL $err_storage_redis | \
    tar zxvf - --strip-components 1 -C $err_storage_redis_dir
)

echo "Errbot backend and storage installed"
