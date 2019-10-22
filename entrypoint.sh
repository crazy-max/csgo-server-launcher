#!/bin/bash

SCREEN_NAME="csgo"
USER="steam"
DIR_STEAMCMD="/var/steamcmd"
DIR_ROOT="/var/steamcmd/games/csgo"
DIR_GAME="$DIR_ROOT/csgo"
DIR_LOGS="$DIR_GAME/logs"
STEAM_RUNSCRIPT="${DIR_STEAMCMD}/runscript_${SCREEN_NAME}"
DAEMON_GAME="srcds_run"

#####

TZ=${TZ:-UTC}
PUID=${PUID:-1000}
PGID=${PGID:-1000}

SSMTP_PORT=${SSMTP_PORT:-25}
SSMTP_HOSTNAME=${SSMTP_HOSTNAME:-$(hostname -f)}
SSMTP_TLS=${SSMTP_TLS:-NO}

IP=${IP:-$(sudo dig -4 +short myip.opendns.com @resolver1.opendns.com)}
PORT=${PORT:-27015}
GSLT=${GSLT}
STEAM_LOGIN=${STEAM_LOGIN:-anonymous}
STEAM_PASSWORD=${STEAM_PASSWORD:-anonymous}
UPDATE_LOG=${DIR_LOGS}/update_$(date +%Y%m%d).log
UPDATE_EMAIL=${UPDATE_EMAIL}
UPDATE_RETRY=${UPDATE_RETRY:-3}
CLEAR_DOWNLOAD_CACHE=${CLEAR_DOWNLOAD_CACHE:-0}
API_AUTHORIZATION_KEY=${API_AUTHORIZATION_KEY}
WORKSHOP_COLLECTION_ID=${WORKSHOP_COLLECTION_ID:-125499818}
WORKSHOP_START_MAP=${WORKSHOP_COLLECTION_ID:-125488374}
MAXPLAYERS=${MAXPLAYERS:-18}
TICKRATE=${TICKRATE:-64}
EXTRAPARAMS=${EXTRAPARAMS:--nohltv +sv_pure 0 +game_type 0 +game_mode 0 +mapgroup mg_active +map de_dust2}

PARAM_START="-nobreakpad -game csgo -console -usercon -secure -autoupdate -steam_dir ${DIR_STEAMCMD} -steamcmd_script ${STEAM_RUNSCRIPT} -maxplayers_override ${MAXPLAYERS} -tickrate ${TICKRATE} +hostport ${PORT} +net_public_adr ${IP} ${EXTRAPARAMS}"
PARAM_UPDATE="+login ${STEAM_LOGIN} ${STEAM_PASSWORD} +force_install_dir ${DIR_ROOT} +app_update 740 validate +quit"

# Timezone
echo "Setting timezone to ${TZ}..."
sudo ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime
echo ${TZ} | sudo tee /etc/timezone > /dev/null

# Change steam UID / GID
echo "Checking if steam UID / GID has changed..."
if [ $(id -u steam) != ${PUID} ]; then
  usermod -u ${PUID} steam
fi
if [ $(id -g steam) != ${PGID} ]; then
  groupmod -g ${PGID} steam
fi

# Check vars
if [ ! -z "$UPDATE_EMAIL" ]; then
  if [ -z "$SSMTP_HOST" ] ; then
    echo "WARNING: SSMTP_HOST must be defined if you want to send emails"
    sudo cp -f /etc/ssmtp/ssmtp.conf.or /etc/ssmtp/ssmtp.conf
    UPDATE_EMAIL=""
  fi
else
  echo "NOTICE: UPDATE_EMAIL is not set"
fi

# SSMTP
if [ ! -z "$SSMTP_HOST" ] ; then
  echo "Setting SSMTP configuration..."
  cat > /tmp/ssmtp.conf <<EOL
mailhub=${SSMTP_HOST}:${SSMTP_PORT}
hostname=${SSMTP_HOSTNAME}
FromLineOverride=YES
UseTLS=${SSMTP_TLS}
UseSTARTTLS=${SSMTP_TLS}
EOL
  # Authentication to SMTP server is optional.
  if [ -n "$SSMTP_USER" ] ; then
    cat >> /etc/ssmtp/ssmtp.conf <<EOL
AuthUser=${SSMTP_USER}
AuthPass=${SSMTP_PASSWORD}
EOL
  fi
  sudo mv -f /tmp/ssmtp.conf /etc/ssmtp/ssmtp.conf
fi
unset SSMTP_HOST
unset SSMTP_USER
unset SSMTP_PASSWORD

# Config
cat > "/etc/csgo-server-launcher/csgo-server-launcher.conf" <<EOL
# This file is an integral part of csgo-server-launcher.
# More info : https://github.com/crazy-max/csgo-server-launcher#installation

SCREEN_NAME="${SCREEN_NAME}"
USER="${USER}"
IP="${IP}"
PORT="${PORT}"

# Anonymous connection will be deprecated in the near future. Therefore it is highly recommended to generate a Game Server Login Token.
GSLT="${GSLT}"

DIR_STEAMCMD="${DIR_STEAMCMD}"
STEAM_LOGIN="${STEAM_LOGIN}"
STEAM_PASSWORD="${STEAM_PASSWORD}"
STEAM_RUNSCRIPT="${STEAM_RUNSCRIPT}"

DIR_ROOT="${DIR_ROOT}"
DIR_GAME="${DIR_GAME}"
DIR_LOGS="${DIR_LOGS}"
DAEMON_GAME="${DAEMON_GAME}"

UPDATE_LOG="${UPDATE_LOG}"
UPDATE_EMAIL="${UPDATE_EMAIL}"
UPDATE_RETRY=${UPDATE_RETRY}
CLEAR_DOWNLOAD_CACHE=${CLEAR_DOWNLOAD_CACHE}

API_AUTHORIZATION_KEY="${API_AUTHORIZATION_KEY}"
WORKSHOP_COLLECTION_ID="${WORKSHOP_COLLECTION_ID}"
WORKSHOP_START_MAP="${WORKSHOP_START_MAP}"

# Game config
MAXPLAYERS="${MAXPLAYERS}"
TICKRATE="${TICKRATE}"
EXTRAPARAMS="${EXTRAPARAMS}"

# Major settings
PARAM_START="${PARAM_START}"
PARAM_UPDATE="${PARAM_UPDATE}"
EOL
unset GSLT
unset API_AUTHORIZATION_KEY

# Perms
echo "Fixing permissions..."
sudo chown -R steam. ${DIR_STEAMCMD} /home/steam /etc/csgo-server-launcher

exec "$@"
