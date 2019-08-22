## Usage

> :bulb: If you use the Docker image, check the README in the [docker](https://github.com/crazy-max/csgo-server-launcher/tree/master/docker) folder.

For the console mod, press CTRL+A then D to stop the screen without stopping the server.

* **start** - Start the server with the `PARAM_START` var in a screen.
* **stop** - Stop the server and close the screen loaded.
* **status** - Display the status of the server (screen down or up)
* **restart** - Restart the server (stop && start)
* **console** - Display the server console where you can enter commands.
* **update** - Update the server based on the `PARAM_UPDATE` then save the log file in LOG_DIR and send an e-mail to `LOG_EMAIL` if the var is filled.
* **create** - Create a server (script must be configured first).

Example : `/etc/init.d/csgo-server-launcher start`
