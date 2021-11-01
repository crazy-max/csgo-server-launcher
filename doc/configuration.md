## Configuration

> :bulb: If you use the Docker image, check the README in the [docker](https://github.com/crazy-max/csgo-server-launcher/tree/master/docker) folder.

Before running the script, you must change some vars in the config file `/etc/csgo-server-launcher/csgo-server-launcher.conf`.<br />
If you change the location of the config file, do not forget to change the path in the csgo-server-launcher script file for the `CONFIG_FILE` var (default `/etc/csgo-server-launcher/csgo-server-launcher.conf`).

#### SCREEN_NAME

The screen name, you can put what you want but it must be unique and must contain only alphanumeric character.<br />
Example: `SCREEN_NAME="csgo"`

#### USER

Name of the linux user who started the server.<br />
Example: `USER="steam"`

#### IP

Your WAN IP address.<br />
Example: `IP="198.51.100.0"`

#### PORT

The port that your server should listen on.<br />
Example: `PORT="27015"`

#### GSLT

Anonymous connection will be deprecated in the near future. Therefore it is highly recommended to generate a Game Server Login Token. More info : http://steamcommunity.com/dev/managegameservers<br />
Example: `GSLT=""`

#### DIR_STEAMCMD

Path to steamcmd.<br />
Example: `DIR_STEAMCMD="/var/steamcmd"`

#### STEAM_LOGIN

Your steam account username.<br />
Example: `STEAM_LOGIN="anonymous"`

#### STEAM_PASSWORD

Your steam account password.<br />
Example: `STEAM_PASSWORD="anonymous"`

#### STEAM_RUNSCRIPT

Name of the script that steamcmd should execute for autoupdate. This file is created on the fly, you don't normally need to change this variable.<br />
Example: `STEAM_RUNSCRIPT="$DIR_STEAMCMD/runscript_$SCREEN_NAME"`

#### DIR_ROOT

Root directory for the server.<br />
Example: `DIR_ROOT="$DIR_STEAMCMD/games/csgo"`

#### DIR_GAME

Path to the game.<br />
Example: `DIR_GAME="$DIR_ROOT/csgo"`

#### DIR_LOGS

Directory of game's logs.<br />
Example: `DIR_LOGS="$DIR_GAME/logs"`

#### DAEMON_GAME

You don't normally need to change this variable.<br />
Example: `DAEMON_GAME="srcds_run"`

#### UPDATE_LOG

The update log file name.<br />
Example: `UPDATE_LOG="$DIR_LOGS/update.log"`

#### UPDATE_EMAIL

Mail address where the update's logs are sent. Leave empty to disable sending mail.<br />
Example: `UPDATE_EMAIL="foo@bar.com"`

#### UPDATE_RETRY

Number of retries in case of failure of the update.<br />
Example: `UPDATE_RETRY=3`

#### CLEAR_DOWNLOAD_CACHE

Set to `1` to remove download cache after an update.<br />
Example: `CLEAR_DOWNLOAD_CACHE=1`

#### API_AUTHORIZATION_KEY

To download maps from the workshop, your server needs access to the steam web api. Leave empty if the `webapi_authkey.txt` file exists. Otherwise, to allow this you'll need an authorization key which you can generate : http://steamcommunity.com/dev/apikey<br />
Example: `API_AUTHORIZATION_KEY=""`

#### WORKSHOP_COLLECTION_ID

A collection id from the Maps Workshop. The API_AUTHORIZATION_KEY is required. More info : https://developer.valvesoftware.com/wiki/CSGO_Workshop_For_Server_Operators<br />
Example: `WORKSHOP_COLLECTION_ID="125499818"`

#### WORKSHOP_START_MAP

A map id in the selected collection (WORKSHOP_COLLECTION_ID). The API_AUTHORIZATION_KEY is required.<br />
Example: `WORKSHOP_START_MAP="125488374"`

#### MAXPLAYERS

Maximum players that can connect.<br />
Example: `MAXPLAYERS="18"`

#### TICKRATE

The tickrate that your server will operate at.<br />
Example: `TICKRATE="64"`

#### EXTRAPARAMS

Custom command line parameters.<br />
Example: `EXTRAPARAMS="-nohltv +sv_pure 0 +game_type 0 +game_mode 0 +mapgroup mg_active +map de_dust2"`

#### PARAM_START

Launch settings server.<br />
Example: `PARAM_START="-game csgo -console -usercon -secure -autoupdate -steam_dir ${DIR_STEAMCMD} -steamcmd_script ${STEAM_RUNSCRIPT} -maxplayers_override ${MAXPLAYERS} -tickrate ${TICKRATE} +hostport ${PORT} +ip ${IP} +net_public_adr ${IP} ${EXTRAPARAMS}"`

#### PARAM_UPDATE

Update settings server.<br />
Example: `PARAM_UPDATE="+login ${STEAM_LOGIN} ${STEAM_PASSWORD} +force_install_dir ${DIR_ROOT} +app_update 730 validate +quit"`
