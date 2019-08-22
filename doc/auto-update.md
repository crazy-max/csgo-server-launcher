## Auto Update

You can automatically update your game server by calling the script in a crontab.
Just add this line in your crontab and change the folder if necessary.

```
0 4 * * *   cd /etc/init.d/ && ./csgo-server-launcher update >/dev/null 2>&1
```

This will update your server every day at 4 am.
