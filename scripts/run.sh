#!/bin/bash
set -euo pipefail

readonly ERRRUN="/app"
readonly WAIT="${WAIT:-5}"
readonly ERRBOT_TEST="${ERRBOT_TEST:-}"

ls -l

for i in data plugins errbackends; do
  [[ ! -d "${ERRRUN}/${i}" ]] && mkdir "${ERRRUN}/${i}"
done

# sleep if we need to wait for another container
if [[ -n ${WAIT} ]]; then
    echo "Sleep ${WAIT} seconds before starting errbot..."
    sleep ${WAIT}
fi

ERRBOT_PORT=${PORT:-3141}
ERRBOT_HOST=0.0.0.0

if [[ -f "${ERRRUN}/config.py" ]] ; then
    errbot_cmd="errbot -c ${ERRRUN}/config.py"
else
    errbot_cmd="errbot"
fi

# enable Webserver
echo "{'configs': {'Webserver': {'HOST': '${ERRBOT_HOST}', 'PORT': ${ERRBOT_PORT}}}}" | $errbot_cmd --storage-merge core

if [[ -n "${ERRBOT_TEST}" ]] ; then
    $errbot_cmd -T
else
    $errbot_cmd
fi

