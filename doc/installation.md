## Installation

* [Docker](#docker)
* [Install script](#install-script)
* [Manual](#manual)

## Docker

An [official docker image](https://hub.docker.com/r/crazymax/csgo-server-launcher/) 🐳 is available for CSGO Server Launcher.<br />
For usage and info, check the README in the [docker](https://github.com/crazy-max/csgo-server-launcher/tree/master/docker) folder.

## Install script

A script is available to perform an installation with a single command:

```
$ sudo curl -sSLk https://github.com/crazy-max/csgo-server-launcher/releases/download/v1.14.4/install.sh | sudo bash
```

This should output something like this:

```
Starting CSGO Server Launcher install (v1.14.4)...

Adding i386 architecture...
Installing required packages...
Downloading CSGO Server Launcher script...
Chmod script...
Install System-V style init script link...
Downloading CSGO Server Launcher configuration...
Checking steam user exists...
Adding steam user...
Creating /var/steamcmd folder...
Updating USER in config file...
Updating IP in config file...
Updating DIR_STEAMCMD in config file...

Done!

DO NOT FORGET to edit the configuration in '/etc/csgo-server-launcher/csgo-server-launcher.conf'
Then type:
  '/etc/init.d/csgo-server-launcher create' to install steam and csgo
  '/etc/init.d/csgo-server-launcher start' to start the csgo server!
```

## Manual

Or you can install it manually as root or sudoer:

```
$ dpkg --add-architecture i386
$ apt-get update
$ apt-get install -y -q curl gdb libc?-i386 lib32stdc++? lib32gcc1 lib32ncurses? lib32z1 libsdl2-2.0-0:i386 screen tar
$ curl -sSLk https://github.com/crazy-max/csgo-server-launcher/releases/download/v1.14.4/csgo-server-launcher.sh -o /etc/init.d/csgo-server-launcher
$ chmod +x /etc/init.d/csgo-server-launcher
$ update-rc.d csgo-server-launcher defaults
$ mkdir -p /etc/csgo-server-launcher/
$ curl -sSLk https://github.com/crazy-max/csgo-server-launcher/releases/download/v1.14.4/csgo-server-launcher.conf -o /etc/csgo-server-launcher/csgo-server-launcher.conf
```

> :warning: Replace lib32ncurses5 with lib32ncurses6 on Debian buster based distros

And you have to create the dedicated user `steam` and the steamcmd directory:

```
$ useradd -m steam
$ mkdir -p /var/steamcmd
$ chown -R steam. /var/steamcmd/
```

After that you can install and start csgo:

```
$ /etc/init.d/csgo-server-launcher create
$ /etc/init.d/csgo-server-launcher start
```
