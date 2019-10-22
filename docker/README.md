## About

[Official docker image](https://hub.docker.com/r/crazymax/csgo-server-launcher/) 🐳 for CSGO Server Launcher.<br />
If you are interested, [check out](https://hub.docker.com/r/crazymax/) my other 🐳 Docker images!

💡 Want to be notified of new releases? Check out 🔔 [Diun (Docker Image Update Notifier)](https://github.com/crazy-max/diun) project!

## Environment variables

* `TZ` : The timezone assigned to the container (default `UTC`)
* `PUID` : The timezone assigned to the container (default `1000`)
* `PGID` : The timezone assigned to the container (default `1000`)
* `SSMTP_HOST` : SMTP server host
* `SSMTP_PORT` : SMTP server port (default `25`)
* `SSMTP_HOSTNAME` : Full hostname (default `$(hostname -f)`)
* `SSMTP_USER` : SMTP username
* `SSMTP_PASSWORD` : SMTP password
* `SSMTP_TLS` : SSL/TLS (default `NO`)

And also the following environment variables to edit the CSGO Server Launcher [configuration](https://github.com/crazy-max/csgo-server-launcher/wiki/Configuration) :

* `IP` (default `$(sudo dig -4 +short myip.opendns.com @resolver1.opendns.com)`)
* `PORT` (default `27015`)
* `GSLT`
* `STEAM_LOGIN` (default `anonymous`)
* `STEAM_PASSWORD` (default `anonymous`)
* `UPDATE_EMAIL`
* `UPDATE_RETRY` (default `3`)
* `CLEAR_DOWNLOAD_CACHE` (default `0`)
* `API_AUTHORIZATION_KEY`
* `WORKSHOP_COLLECTION_ID` (default `125499818`)
* `WORKSHOP_START_MAP` (default `125488374`)
* `MAXPLAYERS` (default `18`)
* `TICKRATE` (default `64`)
* `EXTRAPARAMS` (default `-nohltv +sv_pure 0 +game_type 0 +game_mode 0 +mapgroup mg_active +map de_dust2`)

## Volumes

* `/var/steamcmd/games/csgo` : CSGO root folder
* `/home/steam/Steam` : Steam folder for logs, appcache, etc...

## Usage

### Docker Compose

Docker compose is the recommended way to run this image. Copy the content of folder [examples/compose](examples/compose) in `/var/csgo-server-launcher/` on your host for example. Edit the compose and env files with your preferences and run the following command :

```bash
$ docker-compose up -d
$ docker-compose logs -f
```

### Command line

You can also use the following minimal command :

```bash
$ docker run -dt --name csgo --restart always \
  --ulimit nproc=65535 \
  --ulimit nofile=32000:40000 \
  -p ${PORT}:${PORT} \
  -p ${PORT}:${PORT}/udp \
  --env-file $(pwd)/.env \
  -v $(pwd)/csgo:/var/steamcmd/games/csgo \
  -v $(pwd)/steam:/home/steam/Steam \
  crazymax/csgo-server-launcher:latest
```

> :warning: `${PORT}` is the CSGO server port defined in your `.env` file

## Upgrade image

You can upgrade this image whenever I push an update :

```bash
docker-compose pull
docker-compose up -d
```

## Notes

### Update CSGO

If you use compose, you can update CSGO by using the [updater service](examples/compose/updater.yml) :

```bash
$ docker-compose down              # stop csgo
$ docker-compose -f updater.yml up # start updater
$ docker-compose up -d             # start csgo
```

If you don't use compose :

```bash
$ docker stop csgo
$ docker run -it --name csgo-updater --restart on-failure \
  --env-file $(pwd)/.env \
  -v $(pwd)/csgo:/var/steamcmd/games/csgo \
  -v $(pwd)/steam:/home/steam/Steam \
  crazymax/csgo-server-launcher:latest \
  csgo-server-launcher update
$ docker start csgo
```
