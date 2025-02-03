#!/usr/bin/env bash

##################################################################################
#                                                                                #
#  Installs CSGO Server Launcher                                                 #
#                                                                                #
#  Copyright (C) 2012-2025 CrazyMax                                              #
#                                                                                #
#  Counter-Strike : Global Offensive Server Launcher is free software; you can   #
#  redistribute it and/or modify it under the terms of the GNU Lesser General    #
#  Public License as published by the Free Software Foundation, either version 3 #
#  of the License, or (at your option) any later version.                        #
#                                                                                #
#  Counter-Strike : Global Offensive Server Launcher is distributed in the hope  #
#  that it will be useful, but WITHOUT ANY WARRANTY; without even the implied    #
#  warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the      #
#  GNU Lesser General Public License for more details.                           #
#                                                                                #
#  You should have received a copy of the GNU Lesser General Public License      #
#  along with this program. If not, see http://www.gnu.org/licenses/.            #
#                                                                                #
#  Website: https://github.com/crazy-max/csgo-server-launcher                    #
#                                                                                #
##################################################################################

# Check distrib
if ! command -v apt-get >/dev/null 2>/dev/null; then
  echo "ERROR: OS distribution not supported..."
  exit 1
fi

# Check root
if [ "$EUID" -ne 0 ]; then
  echo "ERROR: Please run this script as root..."
  exit 1
fi

# Install dependencies
echo "Installing dependencies..."
if ! dpkg --add-architecture i386 >/dev/null; then
  echo "ERROR: Cannot add i386 architecture..."
  exit 1
fi
apt-get update >/dev/null
allpkgs=("curl" "dnsutils" "gdb" "screen" "tar" "lib32gcc1" "lib32gcc-s1" "lib32stdc++6" "lib32z1" "libsdl2-2.0-0:i386")
instpkgs=""
for p in "${allpkgs[@]}"; do
  if [ -n "$(apt-cache madison $p 2>/dev/null)" ]; then
    instpkgs="$instpkgs $p"
  fi
done
if ! apt-get install -q -y $instpkgs; then
  echo "ERROR: Cannot install packages..."
  exit 1
fi

: "${CSGOSL_VERSION=v1.17.0}"
: "${CSGOSL_DOWNLOAD_URL=https://github.com/crazy-max/csgo-server-launcher/releases/download/$CSGOSL_VERSION}"
: "${CSGOSL_BASE_DIR=}"

### Vars
version=$CSGOSL_VERSION
downloadUrl=$CSGOSL_DOWNLOAD_URL
scriptName="csgo-server-launcher"
scriptPath="/etc/init.d/$scriptName"
confPath="/etc/csgo-server-launcher/csgo-server-launcher.conf"
steamcmdPath="/var/steamcmd"
user="steam"
ipAddress=$(dig -4 +short myip.opendns.com @resolver1.opendns.com)
if [ -z "$ipAddress" ]; then
  echo "ERROR: Cannot retrieve your public IP address..."
  exit 1
fi

### Start
echo ""
echo "Starting CSGO Server Launcher install (${version})..."
echo ""

if [ -n "$CSGOSL_BASE_DIR" ]; then
  echo "Copying CSGO Server Launcher script..."
  if ! cp -f "$CSGOSL_BASE_DIR/csgo-server-launcher.sh" "$scriptPath"; then
    echo "ERROR: Cannot copy CSGO Server Launcher script..."
    exit 1
  fi
else
  echo "Downloading CSGO Server Launcher script..."
  if ! curl -sSLk "${downloadUrl}/csgo-server-launcher.sh" -o ${scriptPath}; then
    echo "ERROR: Cannot download CSGO Server Launcher script..."
    exit 1
  fi
fi

if ! chmod +x ${scriptPath}; then
  echo "ERROR: Cannot chmod CSGO Server Launcher script..."
  exit 1
fi

echo "Install System-V style init script link..."
if ! update-rc.d csgo-server-launcher defaults >/dev/null; then
  echo "ERROR: Cannot install System-V style init script link..."
  exit 1
fi

mkdir -p /etc/csgo-server-launcher/
if [ -n "$CSGOSL_BASE_DIR" ]; then
  echo "Copying CSGO Server Launcher configuration..."
  if ! cp -f "$CSGOSL_BASE_DIR/csgo-server-launcher.conf" "$confPath"; then
    echo "ERROR: Cannot copy CSGO Server Launcher configuration..."
    exit 1
  fi
else
  echo "Downloading CSGO Server Launcher configuration..."
  if [ ! -f $confPath ]; then
    if ! curl -sSLk "${downloadUrl}/csgo-server-launcher.conf" -o ${confPath}; then
      echo "ERROR: Cannot download CSGO Server Launcher configuration..."
      exit 1
    fi
  fi
fi

echo "Checking $user user exists..."
if ! getent passwd ${user} >/dev/null 2>/dev/null; then
  echo "Adding $user user..."
  if ! useradd -m ${user}; then
    echo "ERROR: Cannot add user $user..."
    exit 1
  fi
else
  mkdir -p ~${user}
fi

echo "Creating $steamcmdPath folder..."
mkdir -p "$steamcmdPath"
chown -R ${user}: "$steamcmdPath"

echo "Updating USER in config file..."
sed "s#USER=\"steam\"#USER=\"$user\"#" -i "$confPath" 1>nul

echo "Updating IP in config file..."
sed "s#IP=\"198.51.100.0\"#IP=\"$ipAddress\"#" -i "$confPath"

echo "Updating DIR_STEAMCMD in config file..."
sed "s#DIR_STEAMCMD=\"/var/steamcmd\"#DIR_STEAMCMD=\"$steamcmdPath\"#" -i "$confPath" 1>nul

echo ""
echo "Done!"
echo ""

echo "DO NOT FORGET to edit the configuration in '$confPath'"
echo "Then type:"
echo "  '$scriptPath create' to install steam and csgo"
echo "  '$scriptPath start' to start the csgo server!"
echo ""
