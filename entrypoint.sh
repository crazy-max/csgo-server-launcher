#!/bin/bash

# From https://github.com/docker-library/mariadb/blob/master/docker-entrypoint.sh#L21-L41
# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
  local var="$1"
  local fileVar="${var}_FILE"
  local def="${2:-}"
  if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
    echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
    exit 1
  fi
  local val="$def"
  if [ "${!var:-}" ]; then
    val="${!var}"
  elif [ "${!fileVar:-}" ]; then
    val="$(< "${!fileVar}")"
  fi
  export "$var"="$val"
  unset "$fileVar"
}

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

#SMTP_HOST=${SMTP_HOST:-smtp.example.com}
#SMTP_PORT=${SMTP_PORT:-25}
#SMTP_TLS=${SMTP_TLS:-off}
#SMTP_STARTTLS=${SMTP_STARTTLS:-off}
#SMTP_TLS_CHECKCERT=${SMTP_TLS_CHECKCERT:-on}
#SMTP_AUTH=${SMTP_AUTH:-off}
#SMTP_USER=${SMTP_USER:-foo}
#SMTP_PASSWORD=${SMTP_PASSWORD:-bar}
#SMTP_FROM=${SMTP_FROM:-foo@example.com}
#SMTP_DOMAIN=${SMTP_DOMAIN:-example.com}

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
WORKSHOP_START_MAP=${WORKSHOP_START_MAP:-125488374}
MAXPLAYERS=${MAXPLAYERS:-18}
TICKRATE=${TICKRATE:-64}
EXTRAPARAMS=${EXTRAPARAMS:--nohltv +sv_pure 0 +game_type 0 +game_mode 0 +mapgroup mg_active +map de_dust2}

PARAM_START="-nobreakpad -game csgo -console -usercon -secure -autoupdate -steam_dir ${DIR_STEAMCMD} -steamcmd_script ${STEAM_RUNSCRIPT} -maxplayers_override ${MAXPLAYERS} -tickrate ${TICKRATE} +hostport ${PORT} +net_public_adr ${IP} ${EXTRAPARAMS}"
PARAM_UPDATE="+force_install_dir ${DIR_ROOT} +login ${STEAM_LOGIN} ${STEAM_PASSWORD} +app_update 740 validate +quit"

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
if [ -n "$UPDATE_EMAIL" ]; then
  if [ -z "$SMTP_HOST" ] ; then
    echo "WARNING: SMTP_HOST must be defined if you want to send emails"
    UPDATE_EMAIL=""
  fi
else
  echo "NOTICE: UPDATE_EMAIL is not set"
fi

# msmtp
if [ -n "$SMTP_HOST" ] ; then
  echo "Setting msmtp configuration..."
  cat << EOF | sudo tee /etc/msmtprc > /dev/null
account default
logfile -
syslog off
host ${SMTP_HOST}
EOF
  file_env 'SMTP_USER'
  file_env 'SMTP_PASSWORD'
  if [ -n "$SMTP_PORT" ];           then echo "port $SMTP_PORT"                    | sudo tee -a /etc/msmtprc > /dev/null; fi
  if [ -n "$SMTP_TLS" ];            then echo "tls $SMTP_TLS"                      | sudo tee -a /etc/msmtprc > /dev/null; fi
  if [ -n "$SMTP_STARTTLS" ];       then echo "tls_starttls $SMTP_STARTTLS"        | sudo tee -a /etc/msmtprc > /dev/null; fi
  if [ -n "$SMTP_TLS_CHECKCERT" ];  then echo "tls_certcheck $SMTP_TLS_CHECKCERT"  | sudo tee -a /etc/msmtprc > /dev/null; fi
  if [ -n "$SMTP_AUTH" ];           then echo "auth $SMTP_AUTH"                    | sudo tee -a /etc/msmtprc > /dev/null; fi
  if [ -n "$SMTP_USER" ];           then echo "user $SMTP_USER"                    | sudo tee -a /etc/msmtprc > /dev/null; fi
  if [ -n "$SMTP_PASSWORD" ];       then echo "password $SMTP_PASSWORD"            | sudo tee -a /etc/msmtprc > /dev/null; fi
  if [ -n "$SMTP_FROM" ];           then echo "from $SMTP_FROM"                    | sudo tee -a /etc/msmtprc > /dev/null; fi
  if [ -n "$SMTP_DOMAIN" ];         then echo "domain $SMTP_DOMAIN"                | sudo tee -a /etc/msmtprc > /dev/null; fi
fi
unset SMTP_HOST
unset SMTP_USER
unset SMTP_PASSWORD

# Config
file_env 'GSLT'
file_env 'STEAM_LOGIN'
file_env 'STEAM_PASSWORD'
file_env 'API_AUTHORIZATION_KEY'
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
unset STEAM_LOGIN
unset STEAM_PASSWORD
unset API_AUTHORIZATION_KEY

# Perms
echo "Fixing permissions..."
sudo chown -R steam. ${DIR_STEAMCMD} /home/steam /etc/csgo-server-launcher

exec "$@"
