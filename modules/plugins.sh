#!/bin/bash

echo "Installing selected plugins..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

PLUGINS_JSON="$ROOT_DIR/plugins.json"

if [ ! -f "$PLUGINS_JSON" ]; then
    echo "plugins.json not found. Skipping plugin installation."
    return
fi

SERVER_DIR="/home/cs2server/serverfiles/game/csgo"
PLUGIN_DIR="$SERVER_DIR/addons/counterstrikesharp/plugins"

mkdir -p "$PLUGIN_DIR"

for plugin in $(jq -r 'keys[]' "$PLUGINS_JSON"); do

    URL=$(jq -r ".\"$plugin\".url" "$PLUGINS_JSON")

    if [ "$URL" = "null" ] || [ -z "$URL" ]; then
        echo "Skipping $plugin (no URL)"
        continue
    fi

    if [ -d "$PLUGIN_DIR/$plugin" ]; then
        echo "$plugin already installed. Skipping."
        continue
    fi

    VERSION=$(basename "$URL" | sed 's/.zip//')

    echo "Installing $plugin ($VERSION)..."

    TMP_DIR="/tmp/plugin-$plugin"
    rm -rf "$TMP_DIR"
    mkdir -p "$TMP_DIR"

    cd "$TMP_DIR" || exit

    wget -q "$URL" -O plugin.zip
    unzip -q plugin.zip

    ########################################
    # Find the addons folder anywhere
    ########################################

    ADDONS_FOUND=$(find . -type d -name addons | head -n 1)

    if [ -n "$ADDONS_FOUND" ]; then
        echo "Copying addons directory..."
        cp -r "$ADDONS_FOUND"/* "$SERVER_DIR/addons/"
    else
        echo "No addons folder found in $plugin archive"
    fi

    cd /tmp
    rm -rf "$TMP_DIR"

done

chown -R cs2server:cs2server /home/cs2server/serverfiles

echo "Plugin installation finished."