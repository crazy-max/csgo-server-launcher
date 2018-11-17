## About

[Official docker image](https://hub.docker.com/r/crazymax/csgo-server-launcher/) 🐳 for CSGO Server Launcher.<br />
If you are interested, [check out](https://hub.docker.com/r/crazymax/) my other 🐳 Docker images!

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

* `IP` (default `$(sudo dig +short myip.opendns.com @resolver1.opendns.com)`)
* `GSLT`
* `STEAM_LOGIN` (default `anonymous`)
* `STEAM_PASSWORD` (default `anonymous`)
* `UPDATE_EMAIL`
* `UPDATE_RETRY` (default `3`)
* `API_AUTHORIZATION_KEY`
* `WORKSHOP_COLLECTION_ID` (default `125499818`)
* `WORKSHOP_START_MAP` (default `125488374`)
* `MAXPLAYERS` (default `18`)
* `TICKRATE` (default `64`)
* `EXTRAPARAMS` (default `-nohltv +sv_pure 0 +game_type 0 +game_mode 0 +mapgroup mg_active +map de_dust2`)

## Volumes

* `/var/steamcmd/games/csgo` : CSGO root folder
* `/home/steam/Steam` : Steam folder for logs, appcache, etc...

## Ports

* `27015 27015/udp` : CSGO server port

## Usage

### Docker Compose

Docker compose is the recommended way to run this image. Copy the content of folder [examples/compose](examples/compose) in `/var/csgo-server-launcher/` on your host for example. Edit the compose file with your preferences and run the following command :

```bash
$ docker-compose up -d
$ docker-compose logs -f
```

### Command line

You can also use the following minimal command :

```bash
$ docker run -dt --name csgo-server-launcher \
  --ulimit nproc=65535 \
  --ulimit nofile=32000:40000 \
  -p 27015:27015 \
  -p 27015:27015/udp \
  --env-file $(pwd)/csgo-server-launcher.env \
  -v $(pwd)/csgo:/var/steamcmd/games/csgo \
  -v $(pwd)/steam:/home/steam/Steam \
  crazymax/csgo-server-launcher:latest
```
