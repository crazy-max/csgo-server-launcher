#! /bin/bash

##################################################################################
#                                                                                #
#  Counter-Strike : Global Offensive Server Launcher                             #
#                                                                                #
#  Author: Cr@zy                                                                 #
#  Contact: http://www.crazyws.fr                                                #
#  Related post: http://goo.gl/HFFGy                                             #
#                                                                                #
#  This program is free software: you can redistribute it and/or modify it       #
#  under the terms of the GNU General Public License as published by the Free    #
#  Software Foundation, either version 3 of the License, or (at your option)     #
#  any later version.                                                            #
#                                                                                #
#  This program is distributed in the hope that it will be useful, but WITHOUT   #
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS #
#  FOR A PARTICULAR PURPOSE. See the GNU General Public License for more         #
#  details.                                                                      #
#                                                                                #
#  You should have received a copy of the GNU General Public License along       #
#  with this program.  If not, see http://www.gnu.org/licenses/.                 #
#                                                                                #
#  Usage: ./csgo-server-launcher.sh {start|stop|status|restart|console|update}   #
#    - start: start the server                                                   #
#    - stop: stop the server                                                     #
#    - status: display the status of the server (down or up)                     #
#    - restart: restart the server                                               #
#    - console: display the server console where you can enter commands.         #
#     To exit the console without stopping the server, press CTRL + A then D.    #
#    - update: update the server                                                 #
#                                                                                #
##################################################################################

SCREEN_NAME="csgo"
USER="steam"
IP="1.2.3.4"

DIR_STEAMCMD="/var/steamcmd"
STEAM_LOGIN="username"
STEAM_PASSWORD="password"
STEAM_RUNSCRIPT="$DIR_STEAMCMD/runscript_$SCREEN_NAME"

DIR_ROOT="$DIR_STEAMCMD/games/csgo"
DIR_GAME="$DIR_ROOT/csgo"
DIR_LOGS="$DIR_GAME/logs"
DAEMON_GAME="srcds_run"

UPDATE_LOG="$DIR_LOGS/update_`date +%Y%m%d`.log"
UPDATE_EMAIL="monitoring@foo.com"
UPDATE_RETRY=3

# Workshop : https://developer.valvesoftware.com/wiki/CSGO_Workshop_For_Server_Operators
API_AUTHORIZATION_KEY="" # http://steamcommunity.com/dev/registerkey
WORKSHOP_COLLECTION_ID="125499818" # http://steamcommunity.com/sharedfiles/filedetails/?id=125499818
WORKSHOP_START_MAP="125488374" # http://steamcommunity.com/sharedfiles/filedetails/?id=125488374

PARAM_START="-game csgo -console -usercon -secure -autoupdate -steam_dir ${DIR_STEAMCMD} -steamcmd_script ${STEAM_RUNSCRIPT} -nohltv -maxplayers_override 28 +sv_pure 0 +hostport 27015 +ip ${IP} +net_public_adr ${IP} +game_type 0 +game_mode 0 +mapgroup mg_bomb +map de_dust2"
PARAM_UPDATE="+login ${STEAM_LOGIN} ${STEAM_PASSWORD} +force_install_dir ${DIR_ROOT} +app_update 740 validate +quit"

# Do not change this path
PATH=/bin:/usr/bin:/sbin:/usr/sbin

# No edits necessary beyond this line
if [ ! -x `which awk` ]; then echo "ERROR: You need awk for this script (try apt-get install awk)"; exit 1; fi
if [ ! -x `which screen` ]; then echo "ERROR: You need screen for this script (try apt-get install screen)"; exit 1; fi

function start {
  if [ ! -d $DIR_ROOT ]; then echo "ERROR: $DIR_ROOT is not a directory"; exit 1; fi
  if [ ! -x $DIR_ROOT/$DAEMON_GAME ]; then echo "ERROR: $DIR_ROOT/$DAEMON_GAME does not exist or is not executable"; exit 1; fi
  if status; then echo "$SCREEN_NAME is already running"; exit 1; fi
  
  # Create runscript file for autoupdate
  echo "Create runscript file '$STEAM_RUNSCRIPT' for autoupdate..."
  cd $DIR_STEAMCMD
  echo "login $STEAM_LOGIN $STEAM_PASSWORD" > $STEAM_RUNSCRIPT
  echo "force_install_dir $DIR_ROOT" >> $STEAM_RUNSCRIPT
  echo "app_update 740" >> $STEAM_RUNSCRIPT
  echo "quit" >> $STEAM_RUNSCRIPT
  chown $USER $STEAM_RUNSCRIPT
  chmod 600 $STEAM_RUNSCRIPT
  
  # Generated misc args
  GENERATED_ARGS="";
  if [ -z "${API_AUTHORIZATION_KEY}" -a -f $DIR_GAME/webapi_authkey.txt ]; then API_AUTHORIZATION_KEY="`cat $DIR_GAME/webapi_authkey.txt`"; fi
  if [ ! -z "${API_AUTHORIZATION_KEY}" ]
  then
    GENERATED_ARGS="-authkey ${API_AUTHORIZATION_KEY}"
    if [ ! -z "${WORKSHOP_COLLECTION_ID}" ]; then GENERATED_ARGS="${GENERATED_ARGS} +host_workshop_collection ${WORKSHOP_COLLECTION_ID}"; fi
    if [ ! -z "${WORKSHOP_START_MAP}" ]; then GENERATED_ARGS="${GENERATED_ARGS} +workshop_start_map ${WORKSHOP_START_MAP}"; fi
  fi
  
  # Start game
  PARAM_START="${PARAM_START} ${GENERATED_ARGS}"
  echo "Start command : $PARAM_START"
  
  if [ `whoami` = root ]
  then
    su - $USER -c "cd $DIR_ROOT ; screen -AmdS $SCREEN_NAME ./$DAEMON_GAME $PARAM_START"
  else
    cd $DIR_ROOT
    screen -AmdS $SCREEN_NAME ./$DAEMON_GAME $PARAM_START
  fi
}

function stop {
  if ! status; then echo "$SCREEN_NAME could not be found. Probably not running."; exit 1; fi

  if [ `whoami` = root ]
  then
    tmp=$(su - $USER -c "screen -ls" | awk -F . "/\.$SCREEN_NAME\t/ {print $1}" | awk '{print $1}')
    su - $USER -c "screen -r $tmp -X quit"
  else
    screen -r $(screen -ls | awk -F . "/\.$SCREEN_NAME\t/ {print $1}" | awk '{print $1}') -X quit
  fi
}

function status {
  if [ `whoami` = root ]
  then
    su - $USER -c "screen -ls" | grep [.]$SCREEN_NAME[[:space:]] > /dev/null
  else
    screen -ls | grep [.]$SCREEN_NAME[[:space:]] > /dev/null
  fi
}

function console {
  if ! status; then echo "$SCREEN_NAME could not be found. Probably not running."; exit 1; fi

  if [ `whoami` = root ]
  then
    tmp=$(su - $USER -c "screen -ls" | awk -F . "/\.$SCREEN_NAME\t/ {print $1}" | awk '{print $1}')
    su - $USER -c "screen -r $tmp"
  else
    screen -r $(screen -ls | awk -F . "/\.$SCREEN_NAME\t/ {print $1}" | awk '{print $1}')
  fi
}

function update {
  if [ ! -d $DIR_LOGS ]; then mkdir $DIR_LOGS; fi
  if [ -z "$1" ]; then retry=0; else retry=$1; fi
  
  if [ -z "$2" ]
  then
    if status
    then
      stop
      echo "Stop $SCREEN_NAME before update..."
      sleep 5
      relaunch=1
    else
      relaunch=0
    fi
  else
    relaunch=$2
  fi
  
  # save motd.txt before update
  if [ -f "$DIR_GAME/motd.txt" ]; then cp $DIR_GAME/motd.txt $DIR_GAME/motd.txt.bck; fi
  
  echo "Starting the $SCREEN_NAME update..."
  
  if [ `whoami` = root ]
  then
    su - $USER -c "cd $DIR_STEAMCMD ; ./steamcmd.sh $PARAM_UPDATE 2>&1 | tee $UPDATE_LOG"
  else
    cd $DIR_STEAMCMD
    ./steamcmd.sh $PARAM_UPDATE 2>&1 | tee $UPDATE_LOG
  fi
  
  # restore motd.txt
  if [ -f "$DIR_GAME/motd.txt.bck" ]; then mv $DIR_GAME/motd.txt.bck $DIR_GAME/motd.txt; fi

  # check for update
  if [ `egrep -ic "Success! App '740' fully installed." "$UPDATE_LOG"` -gt 0 ] || [ `egrep -ic "Success! App '740' already up to date" "$UPDATE_LOG"` -gt 0 ]
  then
    echo "$SCREEN_NAME updated successfully"
  else
    if [ $retry -lt $UPDATE_RETRY ]
    then
      retry=`expr $retry + 1`
      echo "$SCREEN_NAME update failed... retry $retry/3..."
      update $retry $relaunch
    else
      echo "$SCREEN_NAME update failed... exit..."
      exit 1
    fi
  fi
  
  # send e-mail
  if [ ! -z "$UPDATE_EMAIL" ]; then cat $UPDATE_LOG | mail -s "$SCREEN_NAME update for $(hostname -f)" $UPDATE_EMAIL; fi
  
  if [ $relaunch = 1 ]
  then
    echo "Restart $SCREEN_NAME..."
    start
    sleep 5
    echo "$SCREEN_NAME restarted successfully"
  else
    exit 1
  fi
}

function usage {
  echo "Usage: $0 {start|stop|status|restart|console|update}"
  echo "On console, press CTRL+A then D to stop the screen without stopping the server."
}

case "$1" in

  start)
    echo "Starting $SCREEN_NAME..."
    start
    sleep 5
    echo "$SCREEN_NAME started successfully"
  ;;

  stop)
    echo "Stopping $SCREEN_NAME..."
    stop
    sleep 5
    echo "$SCREEN_NAME stopped successfully"
  ;;
 
  restart)
    echo "Restarting $SCREEN_NAME..."
    status && stop
    sleep 5
    start
    sleep 5
    echo "$SCREEN_NAME restarted successfully"
  ;;

  status)
    if status
    then echo "$SCREEN_NAME is UP"
    else echo "$SCREEN_NAME is DOWN"
    fi
  ;;
 
  console)
    echo "Open console on $SCREEN_NAME..."
    console
  ;;
  
  update)
    echo "Updating $SCREEN_NAME..."
    update
  ;;

  *)
    usage
    exit 1
  ;;

esac

exit 0

