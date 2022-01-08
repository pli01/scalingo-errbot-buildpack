# Errbot - the pluggable chatbot

FROM amd64/debian:stable

ENV ERR_USER errbot
ENV DEBIAN_FRONTEND noninteractive
ENV PATH /app/venv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Set default locale for the environment
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Add errbot user and group
RUN groupadd -r $ERR_USER \
    && useradd -r \
       -g $ERR_USER \
       -d /srv \
       -s /bin/bash \
       $ERR_USER
# Install packages and perform cleanup
COPY Aptfile /app/Aptfile
RUN apt-get update \
  && apt-get -y install --no-install-recommends $(cat /app/Aptfile) locales \
    && locale-gen C.UTF-8 \
    && /usr/sbin/update-locale LANG=C.UTF-8 \
    && echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen \
    && locale-gen \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/archives

COPY requirements.txt /app/requirements.txt
#COPY plugins /app/plugins

RUN pip3 install --no-cache-dir -r /app/requirements.txt ; \
    err_backend_mattermost="https://github.com/errbotio/err-backend-mattermost/archive/refs/heads/master.tar.gz" ; \
    err_backend_mattermost_dir="err-backend-mattermost" ; \
    err_storage_redis="https://github.com/errbotio/err-storage-redis/archive/refs/heads/master.tar.gz" ; \
    err_storage_redis_dir="err-storage-redis" ; \
    mkdir /app/errbackends ; \
    ( cd /app/errbackends ; \
      mkdir ${err_backend_mattermost_dir} ; \
      curl -sL $err_backend_mattermost | \
        tar zxvf - --strip-components 1 -C ${err_backend_mattermost_dir} ; \
      pip3 install --no-cache-dir -r ${err_backend_mattermost_dir}/requirements.txt ) ; \
    mkdir /app/errstorage/ ; \
    ( cd /app/errstorage ; \
      mkdir ${err_storage_redis_dir} ; \
      curl -sL $err_storage_redis | \
        tar zxvf - --strip-components 1 -C ${err_storage_redis_dir} ; \
      pip3 install --no-cache-dir -r ${err_storage_redis_dir}/requirements.txt )

COPY config.py /app/config.py
COPY scripts/run.sh /app/run.sh

RUN mkdir /srv/data /srv/plugins /srv/errbackends && chown -R $ERR_USER: /srv /app

EXPOSE 3141 3142
VOLUME ["/srv"]
WORKDIR /srv

ENTRYPOINT ["/app/run.sh"]
