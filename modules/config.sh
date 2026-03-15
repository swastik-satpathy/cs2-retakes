#!/bin/bash

echo "Configuring server files..."

CFG_DIR="/home/cs2server/serverfiles/game/csgo/cfg"
CS2SERVER_CFG="$CFG_DIR/cs2server.cfg"
TEMPLATE_CFG="/home/cs2server/cs2-retakes/templates/cs2server.cfg"
MAPCYCLE="/home/cs2server/serverfiles/game/csgo/mapcycle.txt"

mkdir -p "$CFG_DIR"

########################################
# cs2server.cfg from template
########################################

if [ ! -f "$CS2SERVER_CFG" ]; then
    echo "Copying template to cs2server.cfg"
    cp "$TEMPLATE_CFG" "$CS2SERVER_CFG"
else
    echo "cs2server.cfg already exists. Skipping."
fi

########################################
# Replace template placeholders
########################################

sed -i "s/{{SERVER_NAME}}/$SERVER_NAME/g" "$CS2SERVER_CFG"
sed -i "s/{{SERVER_TAGS}}/$SERVER_TAGS/g" "$CS2SERVER_CFG"

########################################
# mapcycle.txt
########################################

if [ ! -f "$MAPCYCLE" ]; then
    echo "Creating mapcycle.txt"
    cat <<EOF > "$MAPCYCLE"
de_mirage
de_dust2
de_inferno
de_nuke
de_ancient
de_anubis
de_overpass
de_vertigo
EOF
else
    echo "mapcycle.txt already exists. Skipping."
fi

########################################
# Permissions
########################################

chown cs2server:cs2server "$CS2SERVER_CFG" "$MAPCYCLE"

echo "Server configuration complete."