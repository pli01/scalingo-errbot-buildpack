# Scalingo Errbot Buildpack

[![Build](https://github.com/pli01/scalingo-errbot-buildpack/actions/workflows/main.yml/badge.svg)](https://github.com/pli01/scalingo-errbot-buildpack/actions/workflows/main.yml)

This buildpack aims at deploying an errbot instance on the Scalingo PaaS platform.

[![Deploy to Scalingo](https://cdn.scalingo.com/deploy/button.svg)](https://my.scalingo.com/deploy?source=https://github.com/pli01/scalingo-errbot-buildpack#main)

# Errbot

![errbot](https://errbot.readthedocs.io/en/latest/_static/errbot.png)

Errbot is a chatbot, a daemon that connects to your favorite chat service and brings your tools into the conversation

See Errbot [errbot.io](http://errbot.io)

included in this buildpack:
- [errboot](https://github.com/errbotio/errbot/)
- backend: [mattermost](https://github.com/errbotio/err-backend-mattermost)
- storage: [redis](https://github.com/errbotio/err-storage-redis)

# Buildpack

This buildpack does the following (see `bin/compile` for details)

- load a `Scalingo/multi-buildpack` to install `Aptfile` and Pip `requirements.txt`
- install `errbot`
- install `Mattermost` backend for errbot
- install `Redis` storage for errbot
- provide a ready errbot config: `config.py`
- start `run.sh` at boot time

# Usage

To deploy an errbot instance app on scalingo:
- define BUILDPACK_URL=url_to_this_buildpack
- If you want to use `Redis` storage errbot, add a redis addons to your app before starting your app
- Define the environment variable (sample below)

Minimal Pre req: 
- a mattermost accessible url: (`BOT_SERVER`)
- a bot account on mattermost: (`BOT_TOKEN`)
- add the bot account to a mattermost team (`BOT_TEAM`)
- add the bot account on a channel in a team (`~my-bot-channel`)
- define ad bot admins comma separated list: (`BOT_ADMINS`)
- a redis url: (`REDIS_URL`)
- Optionnal: customize `ACCESS_CONTROLS`

```bash
STORAGE=Redis
REDIS_URL=redis://:PWD@redisXXXX.scalingo.com
# Backend
BACKEND=Mattermost
BOT_PORT=443
BOT_SCHEME=https
BOT_SERVER=mattermost.mydomain.org
BOT_SSL=True
BOT_TOKEN=CHANGEME
BOT_TEAM=MyTeam
BOT_ADMINS=@usertest
# ACL
ACCESS_CONTROLS={"status":{"allowprivate":True,"allowusers":("@usertest")},"about":{"allowrooms":("~my-bot-channel")},"uptime":{"allowusers":("@usertest")},"help":{"allowrooms":("~my-bot-channel")},"helo":{"allowrooms":("~my-bot-channel")},"betaservices":{"allowrooms":("~my-bot-channel")}}
# global configuration
CORE_PLUGINS=Webserver,Help,ACLs,Health,Utils,TextCmds,VersionChecker,CommandNotFoundFilter,Plugins
DIVERT_TO_PRIVATE=help,about,status,health,utils
HIDE_RESTRICTED_ACCESS=True
HIDE_RESTRICTED_COMMANDS=True
BOT_LOG_LEVEL=DEBUG # INFO
```

# Deploy a custom application on Scalingo
If you want to develop and deploy your own plugin and config file

Create a git repostitory for your Scalingo application:

- add this url buildpack in your `.buildpacks` file
- create a `plugins` dir to add your custom plugins (see errbot.io documentation)
- create a `requirements.txt` file to add your plugins package dependencies
- You can override the default `config.py` with your own `config.py` file in your git application repository. a default `config.py` is provided in the buildpack. It load environement variables. 

Sample git errbot scalingo app structure:
```
config.py
plugins/
plugins/err-hello
plugins/err-hello/hello.py
plugins/err-hello/test_hello.py
plugins/err-hello/hello.plug
requirements.txt
```
