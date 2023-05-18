# Changelog

## 1.17.0 (2023/05/18)

* Move `force_install_dir` before logon (#116)
* Enable and fix e2e test (#115)

## 1.16.0 (2021/01/23)

* Debian Bullseye
* Fix install script

## 1.15.2 (2021/03/09)

* Upstream Debian update
* Switch to buildx bake
* Publish to GHCR

## 1.15.1 (2020/06/22)

* Minor text improvement (#75)

## 1.15.0 (2020/06/05)

* (docker) Docker image based on Debian buster
* (docker) Replace `ssmtp` with `msmtp`
* Add missing `libsdl2-2.0-0:i386`
* (docker) `GSLT_FILE`, `STEAM_LOGIN_FILE`, `STEAM_PASSWORD_FILE` and `API_AUTHORIZATION_KEY_FILE` can be used to fill in the value from a file, especially for Docker's secrets feature.
* (docker) `SSMTP_*` env vars for Docker removed. See [Environment variables](https://github.com/crazy-max/csgo-server-launcher/tree/master/docker#environment-variables) section.

## 1.14.4 (2020/05/29)

* Fix incorrect variable reference (#69)

## 1.14.3 (2020/04/16)

* Fix `lib32ncurses` resolution (#68)

## 1.14.2 (2020/02/23)

* (docker) Switch to Open Container Specification labels as label-schema.org ones are deprecated

## 1.14.1 (2019/10/22)

* Allow to set a custom hostport for Docker (Issue #61)
* Fix ssmtp.conf permission denied

## 1.14.0 (2019/10/11)

* Switch to GitHub Actions
* (docker) Stop publishing Docker image on Quay
* lib32ncurses6 on Debian buster (Issue #60)
* Do not overwrite config for install script (Issue #58)
* (docker) Only populate AuthUser/Pass in ssmtp.conf if defined in ENV

## 1.13.5 (2019/09/08)

* Update steamcmd link

## 1.13.4 (2019/05/27)

* Fix hosts with an IPv6 address failing on getting own ip address (PR #46)

## 1.13.3 (2019/02/04)

* Update Docker build script
* Switch to TravisCI com

## 1.13.2 (2018/11/18)

* Fix error while starting server

## 1.13.1 (2018/11/18)

* (docker) Add update instructions in the wiki
* (docker) Fix permissions issue
* Add an option to clean download cache after an update (Issue #31)
* Use id -u instead of whoami (Issue #23)

## 1.13.0 (2018/11/17)

* Add official Docker image
* Patch srcds_run
* Check daemon exists
* `mg_active` mapgroup instead of `mg_bomb`

## 1.12.3 (2017/07/04)

* Bug with screen >= 4.5.0 on Debian 9 (Issue #38)
* Add install script

## 1.12.2 (2017/05/27)

* Error while loading `server.so` (Issue #37)

## 1.12.1 (2017/04/23)

* Create a symlink for steamclient.so (Issue #35)
* Add screenlog (Issue #34)
* Use type instead of which (Issue #33)
* Can't access console (Issue #19)
* Add FAQ in README.md
* Code style

## 1.12 (2017/04/22)

* Bad line ending (Issue #32)

## 1.11 (2017/04/21)

* Minor update
* Add CHANGELOG

## 1.10 (2015/12/09)

* Add game server login token support (Issue #26)

## 1.9 (2015/02/19)

* Move config in an other file
* Adding init.d info (as a service)
* Launch on startup feature

## 1.8 (2014/01/21)

* Fix script headers
* Add GNU LGPL license

## 0.8 (2013/07/10)

* Add create command
* Steam can now be automatically installed to DIR_STEAMCMD
* Create the log and game directory automatically to get rid of some errors

## 0.7 (2013/06/19)

* Add maxplayersand tickrate.
* Update maxplayers_override to be user controlled.
* Add the tickrate command line option.
* Check if the webapi_authkey.txt exists.

## 0.6 (2013/03/30)

* Chmod bug

## 0.5 (2013/03/28)

* Add workshop collection vars.
* Secure steam runscript.
* Bug if motd doesn't exist.
* Change update command.
* Display start command args.
* Syntax bug

## 0.4 (2013/02/13)

* Neverending loop during update process.
* Add +ip to bind to an IP if your device has more than one IP
* Carriage return causing problems in the script

## 0.3 (2012/09/11)

* Add -autoupdate option in the PARAM_START var.
* Sending e-mail only if the UPDATE_EMAIL var is filled.
* Save csgo/motd.txt before update (overwritten file after update)
* Adding a variable for the maximum number of retries in case of failure of the update.

## 0.2 (2012/08/29)

* Host port is required if you set a different port than 27015 for multiple instances
* Send e-mail with log after update
* Now the update is done with all the necessary parameters rather than parameter +runscript

## 0.1 (2012/08/27)

* Initial version
