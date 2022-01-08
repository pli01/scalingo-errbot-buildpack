SHELL = /bin/bash
APP_NAME=scalingo-errbot-buildpack
#APP_VERSION := $(shell bash ./ci/version.sh 2>&- || cat VERSION)
DC       := $(shell type -p docker-compose)
DC_BUILD_ARGS := --pull --no-cache --force-rm
DC_APP_DOCKER_CLI := docker-compose.yml
DC_APP_ENV :=  #-f docker-compose.test.yml

USE_TTY := $(shell test -t 1 && USE_TTY="-t")
DC_RUN_ARGS := --rm ${USE_TTY}

export

all:
	@echo "Usage: make build | config"
build: config
	${DC} -f ${DC_APP_DOCKER_CLI}  build ${DC_BUILD_ARGS}
config:
	@${DC} -f ${DC_APP_DOCKER_CLI} ${DC_APP_ENV} config
up:
	${DC} -f ${DC_APP_DOCKER_CLI} ${DC_APP_ENV} up -d
up-%:
	${DC} -f ${DC_APP_DOCKER_CLI} ${DC_APP_ENV} up -d $*
down:
	${DC} -f ${DC_APP_DOCKER_CLI} ${DC_APP_ENV} down
rm:
	${DC} -f ${DC_APP_DOCKER_CLI} ${DC_APP_ENV} rm -f

run-%:
	${DC} -f ${DC_APP_DOCKER_CLI} ${DC_APP_ENV} run ${DC_RUN_ARGS} $*
bash-%:
	${DC} -f ${DC_APP_DOCKER_CLI} ${DC_APP_ENV} run --entrypoint='/bin/bash' ${DC_RUN_ARGS} $*

version-${APP_NAME}:
	${DC} -f ${DC_APP_DOCKER_CLI} ${DC_APP_ENV} run --entrypoint='/bin/bash' ${DC_RUN_ARGS} ${APP_NAME} -c 'errbot -c /app/config.py -v'
