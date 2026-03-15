#!/bin/bash

set -euo pipefail

LOG="logs/installer.log"
mkdir -p logs

exec > >(tee -a $LOG)
exec 2>&1

source cli.sh

if id "cs2server" &>/dev/null; then
  echo "Existing install detected"
  read -p "Repair existing install? (y/n): " repair
fi


if [ -d "/home/cs2server/serverfiles" ]; then
    echo "Existing CS2 installation detected."
    read -rp "Repair installation? (y/n): " repair

    if [[ "$repair" != "y" ]]; then
        echo "Aborting install."
        exit 1
    fi
fi

if id "cs2server" &>/dev/null; then
    echo "User cs2server already exists"
else
    echo "Creating user cs2server"

    if [ -d /home/cs2server ]; then
        useradd -d /home/cs2server -s /bin/bash cs2server
    else
        useradd -m -s /bin/bash cs2server
    fi
fi

source modules/dependencies.sh
source modules/lgsm.sh
source modules/metamod.sh
source modules/cssharp.sh
source modules/database.sh
source modules/plugins.sh
source modules/admin.sh
source modules/cron.sh
#source modules/updater.sh


CONFIG="/home/cs2server/serverfiles/game/csgo/cfg/server.cfg"

cp templates/server.cfg $CONFIG

sed -i "s/{{SERVER_NAME}}/$SERVER_NAME/" $CONFIG
sed -i "s/{{SERVER_TAGS}}/$SERVER_TAGS/" $CONFIG

echo "Install complete"