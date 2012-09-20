Counter-Strike : Global Offensive Server Launcher
=================================================

A simple script to launch your Counter-Strike : Global Offensive Dedicated Server.
Tested on Debian and Ubuntu.

Installation
------------

Before running the script, you must change some variables.

* **SCREEN_NAME** - The screen name, you can put what you want but it must be unique and must contain only alphanumeric character.
* **USER** - Name of the user who started the server.
* **IP** - Your WAN IP address.
* **DIR_STEAMCMD** - Path to steamcmd.
* **STEAM_LOGIN** - Your steam account username.
* **STEAM_PASSWORD** - Your steam account password.
* **STEAM_RUNSCRIPT** - Name of the script that steamcmd should execute for autoupdate. This file is created on the fly, you don't normally need to change this variable.
* **DIR_GAME** - Path to the game.
* **DIR_LOGS** - Directory of game's logs.
* **DAEMON_GAME** - You don't normally need to change this variable.
* **UPDATE_LOG** - The update log file name.
* **UPDATE_EMAIL** - Mail address where the update's logs are sent. Leave empty to disable sending mail.
* **UPDATE_RETRY** - Number of retries in case of failure of the update.
* **PARAM_START** - Launch settings server.
* **PARAM_UPDATE** - Update settings server.

Usage
-----

For the console mod, press CTRL+A then D to stop the screen without stopping the server.

* **start** - Start the server with the PARAM_START var in a screen.
* **stop** - Stop the server and close the screen loaded.
* **status** - Display the status of the server (screen down or up)
* **restart** - Restart the server (stop && start)
* **console** - Display the server console where you can enter commands.
* **update** - Update the server based on the PARAM_UPDATE then save the log file in LOG_DIR and send an e-mail to LOG_EMAIL if the var is filled.

Automatic update with cron
--------------------------

You can automatically update your game server by calling the script in a crontab.
Just add this line in your crontab and change the folder if necessary.

    0 4 * * * cd /var/steamcmd/ && ./csgo update >/dev/null 2>&1
	
This will update your server every day at 4 am.

More infos
----------

http://www.crazyws.fr/tutos/installer-un-serveur-counter-strike-global-offensive-X4LCM.html