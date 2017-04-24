<p align="center"><a href="https://github.com/crazy-max/csgo-server-launcher" target="_blank"><img width="100" src="https://github.com/crazy-max/csgo-server-launcher/blob/master/res/logo.png"></a></p>

<p align="center">
  <a href="https://travis-ci.org/crazy-max/csgo-server-launcher"><img src="https://img.shields.io/travis/crazy-max/csgo-server-launcher/master.svg?style=flat-square" alt="Build Status"></a>
  <a href="https://www.codacy.com/app/crazy-max/csgo-server-launcher"><img src="https://img.shields.io/codacy/grade/41e240a938654db0a667c6614e8ae9d5.svg?style=flat-square" alt="Code Quality"></a>
  <a href="https://github.com/crazy-max/csgo-server-launcher/releases/latest"><img src="https://img.shields.io/github/release/crazy-max/csgo-server-launcher.svg?style=flat-square" alt="GitHub release"></a>
  <a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=3LJDWUWL73GB4"><img src="https://img.shields.io/badge/donate-paypal-blue.svg?style=flat-square" alt="Donate Paypal"></a>
  <a href="https://flattr.com/submit/auto?user_id=crazymax&url=https://github.com/crazy-max/csgo-server-launcher"><img src="https://img.shields.io/badge/flattr-this-green.svg?style=flat-square" alt="Flattr this!"></a>
</p>

## About

A simple script to create and launch your Counter-Strike : Global Offensive Dedicated Server.
Tested on Debian and Ubuntu.

## Requirements

Of course a Steam account is required to create a Counter-Strike : Global Offensive dedicated server.

Required commands :

* [awk](http://en.wikipedia.org/wiki/Awk) is required.
* [screen](http://linux.die.net/man/1/screen) is required.
* [wget](http://en.wikipedia.org/wiki/Wget) is required.
* [tar](http://linuxcommand.org/man_pages/tar1.html) is required.

## Installation

Execute the following commands to download the script :

```console
$ cd /etc/init.d/
$ wget https://raw.githubusercontent.com/crazy-max/csgo-server-launcher/master/csgo-server-launcher.sh -O csgo-server-launcher --no-check-certificate
$ chmod +x csgo-server-launcher
$ update-rc.d csgo-server-launcher defaults
$ mkdir /etc/csgo-server-launcher/
$ wget https://raw.githubusercontent.com/crazy-max/csgo-server-launcher/master/csgo-server-launcher.conf -O /etc/csgo-server-launcher/csgo-server-launcher.conf --no-check-certificate
```

## Configuration

Before running the script, you must change some vars in the config file `/etc/csgo-server-launcher/csgo-server-launcher.conf`.<br />
If you change the location of the config file, do not forget to change the path in the csgo-server-launcher script file for the CONFIG_FILE var (default `/etc/csgo-server-launcher/csgo-server-launcher.conf`).

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
Example: `IP="198.51.100.0"`

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
Example: `EXTRAPARAMS="-nohltv +sv_pure 0 +game_type 0 +game_mode 0 +mapgroup mg_bomb +map de_dust2"`

#### PARAM_START

Launch settings server.<br />
Example: `PARAM_START="-game csgo -console -usercon -secure -autoupdate -steam_dir ${DIR_STEAMCMD} -steamcmd_script ${STEAM_RUNSCRIPT} -maxplayers_override ${MAXPLAYERS} -tickrate ${TICKRATE} +hostport ${PORT} +ip ${IP} +net_public_adr ${IP} ${EXTRAPARAMS}"`

#### PARAM_UPDATE

Update settings server.<br />
Example: `PARAM_UPDATE="+login ${STEAM_LOGIN} ${STEAM_PASSWORD} +force_install_dir ${DIR_ROOT} +app_update 740 validate +quit"`

## Usage

For the console mod, press CTRL+A then D to stop the screen without stopping the server.

* **start** - Start the server with the `PARAM_START` var in a screen.
* **stop** - Stop the server and close the screen loaded.
* **status** - Display the status of the server (screen down or up)
* **restart** - Restart the server (stop && start)
* **console** - Display the server console where you can enter commands.
* **update** - Update the server based on the `PARAM_UPDATE` then save the log file in LOG_DIR and send an e-mail to `LOG_EMAIL` if the var is filled.
* **create** - Create a server (script must be configured first).

Example : `service csgo-server-launcher start`

## Automatic update with cron

You can automatically update your game server by calling the script in a crontab.
Just add this line in your crontab and change the folder if necessary.

```console
0 4 * * * cd /etc/init.d/ && ./csgo-server-launcher update >/dev/null 2>&1
```

This will update your server every day at 4 am.

## FAQ

### cannot create directory "/var/steamcmd"

You've got the following message when you try to install or update steam :

```text
mkdir: cannot create directory "/var/steamcmd": Permission denied
```

It's because you are using a specific user (instead of `root`). Type the following

### steamcmd: No such file or directory

You've got the following message when you try to install or update steam :

```text
./steamcmd.sh: ligne 29: /var/steamcmd/linux32/steamcmd: No such file or directory
```

It's because you are on a 64-bit architecture and you have to to install the 32-bit libraries :

```console
$ apt-get install -y libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1
```

### libcurl.so: cannot open shared object file

```text
libcurl.so: cannot open shared object file: No such file or directory
```

Install `curl` for i386 architecture :

```console
$ dpkg --add-architecture i386
$ apt-get install -y curl:i386
```

## How can i help ?

**CSGO Server Launcher** is free and open source and always will be.<br />
We welcome all kinds of contributions :raised_hands:!<br />
The most basic way to show your support is to star :star2: the project, or to raise issues :speech_balloon:<br />
Any funds donated will be used to help further development on this project! :gift_heart:

<p>
  <a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=3LJDWUWL73GB4">
    <img src="https://github.com/crazy-max/csgo-server-launcher/blob/master/res/paypal.png" alt="Donate Paypal">
  </a>
  <a href="https://flattr.com/submit/auto?user_id=crazymax&url=https://github.com/crazy-max/csgo-server-launcher">
    <img src="https://github.com/crazy-max/csgo-server-launcher/blob/master/res/flattr.png" alt="Flattr this!">
  </a>
</p>

## License

LGPL. See `LICENSE` for more details.
