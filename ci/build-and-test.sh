#!/bin/bash
set -euo pipefail

make build

cp ci/ci-env .env

make up-redis

( echo '!about'  | make run-scalingo-errbot-buildpack  ) | grep "version"

echo $?

make down
