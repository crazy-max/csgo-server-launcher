# Changelog

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
