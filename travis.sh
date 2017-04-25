#!/bin/bash

service csgo-server-launcher create
service csgo-server-launcher start
service csgo-server-launcher status
timeout 180 grep -q 'Connection to Steam servers successful' <(tail -f /var/steamcmd/games/csgo/screenlog.*)
service csgo-server-launcher stop
