#!/usr/bin/env bash

##################################################################################
#                                                                                #
#  Installs CSGO Server Launcher                                                 #
#                                                                                #
#  Copyright (C) 2013-2020 CrazyMax                                              #
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
if ! command -v apt-get &> /dev/null; then
  echo "ERROR: OS distribution not supported..."
  exit 1
fi

# Check root
if [ "$EUID" -ne 0 ]; then
  echo "ERROR: Please run this script as root..."
  exit 1
fi

### Vars
version=1.14.4
downloadUrl="https://github.com/crazy-max/csgo-server-launcher/releases/download/v$version"
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
echo "Starting CSGO Server Launcher install (v${version})..."
echo ""

echo "Adding i386 architecture..."
dpkg --add-architecture i386 >/dev/null
if [ "$?" -ne "0" ]; then
  echo "ERROR: Cannot add i386 architecture..."
  exit 1
fi

echo "Installing required packages..."
apt-get update >/dev/null

apt-get install -y -q libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses? lib32z1 curl gdb screen tar >/dev/null
if [ "$?" -ne "0" ]; then
  echo "ERROR: Cannot install required packages..."
  exit 1
fi

echo "Downloading CSGO Server Launcher script..."
curl -sSLk ${downloadUrl}/csgo-server-launcher.sh -o ${scriptPath}
if [ "$?" -ne "0" ]; then
  echo "ERROR: Cannot download CSGO Server Launcher script..."
  exit 1
fi

echo "Chmod script..."
chmod +x ${scriptPath}
if [ "$?" -ne "0" ]; then
  echo "ERROR: Cannot chmod CSGO Server Launcher script..."
  exit 1
fi

echo "Install System-V style init script link..."
update-rc.d csgo-server-launcher defaults >/dev/null
if [ "$?" -ne "0" ]; then
  echo "ERROR: Cannot install System-V style init script link..."
  exit 1
fi

echo "Downloading CSGO Server Launcher configuration..."
mkdir -p /etc/csgo-server-launcher/
if [ ! -f $confPath ]; then
  curl -sSLk ${downloadUrl}/csgo-server-launcher.conf -o ${confPath}
fi
if [ "$?" -ne "0" ]; then
  echo "ERROR: Cannot download CSGO Server Launcher configuration..."
  exit 1
fi

echo "Checking $user user exists..."
getent passwd ${user} >/dev/null 2&>1
if [ "$?" -ne "0" ]; then
  echo "Adding $user user..."
  useradd -m ${user}
  if [ "$?" -ne "0" ]; then
    echo "ERROR: Cannot add user $user..."
    exit 1
  fi
else
  mkdir -p ~${user}
fi

echo "Creating $steamcmdPath folder..."
mkdir -p "$steamcmdPath"
chown -R ${user}. "$steamcmdPath"

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
