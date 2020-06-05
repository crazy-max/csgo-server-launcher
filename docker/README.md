## About

[Official docker image](https://hub.docker.com/r/crazymax/csgo-server-launcher/) for CSGO Server Launcher.<br />
If you are interested, [check out](https://hub.docker.com/r/crazymax/) my other Docker images!

💡 Want to be notified of new releases? Check out 🔔 [Diun (Docker Image Update Notifier)](https://github.com/crazy-max/diun) project!

## Environment variables

* `TZ`: The timezone assigned to the container (default `UTC`)
* `PUID`: csgo-server-launcher user id (default `1000`)
* `PGID`: csgo-server-launcher group id (default `1000`)
* `SMTP_HOST`: SMTP server host.
* `SMTP_PORT`: SMTP server port. Default `25` or `465` if TLS.
* `SMTP_TLS`: Enable or disable TLS (also known as SSL) for secured connections (`on` or `off`).
* `SMTP_STARTTLS`: Start TLS from within the session (`on`, default), or tunnel the session through TLS (`off`).
* `SMTP_TLS_CHECKCERT`: Enable or disable checks of the server certificate (`on` or `off`). They are enabled by default.
* `SMTP_AUTH`: Enable or disable authentication and optionally [choose a method](https://marlam.de/msmtp/msmtp.html#Authentication-commands) to use. The argument `on` chooses a method automatically.
* `SMTP_USER`: Set the user name for authentication. Authentication must be activated with the `SMTP_AUTH` env var.
* `SMTP_PASSWORD`: Set the password for authentication. Authentication must be activated with the `SMTP_AUTH` env var.
* `SMTP_DOMAIN`: Argument of the `SMTP EHLO` command. Default is `localhost`.
* `SMTP_FROM`: Set the envelope-from address. Supported substitution patterns can be found [here](https://marlam.de/msmtp/msmtp.html#Commands-specific-to-sendmail-mode).

> 💡 `SMTP_USER_FILE` and `SMTP_PASSWORD_FILE` can be used to fill in the value from a file, especially for Docker's secrets feature.

And also the following environment variables to edit the CSGO Server Launcher [configuration](https://github.com/crazy-max/csgo-server-launcher/wiki/Configuration):

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

> 💡 `GSLT_FILE`, `STEAM_LOGIN_FILE`, `STEAM_PASSWORD_FILE` and `API_AUTHORIZATION_KEY_FILE` can be used to fill in the value from a file, especially for Docker's secrets feature.

## Volumes

* `/var/steamcmd/games/csgo`: CSGO root folder
* `/home/steam/Steam`: Steam folder for logs, appcache, etc...

## Usage

### Docker Compose

Docker compose is the recommended way to run this image. Copy the content of folder [examples/compose](examples/compose) in `/var/csgo-server-launcher/` on your host for example. Edit the compose and env files with your preferences and run the following command :

```bash
$ docker-compose up -d
$ docker-compose logs -f
```

### Command line

You can also use the following minimal command:

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

## Upgrade

You can upgrade this image whenever I push an update:

```bash
docker-compose pull
docker-compose up -d
```

## Notes

### Update CSGO

If you use compose, you can update CSGO by using the [updater service](examples/compose/updater.yml):

```bash
$ docker-compose down              # stop csgo
$ docker-compose -f updater.yml up # start updater
$ docker-compose up -d             # start csgo
```

If you don't use compose:

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
