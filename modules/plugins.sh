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

for plugin in $(jq -r 'keys[]' "$PLUGINS_JSON"); do

    URL=$(jq -r ".\"$plugin\".url" "$PLUGINS_JSON")

    if [ "$URL" = "null" ] || [ -z "$URL" ]; then
        echo "Skipping $plugin (no URL)"
        continue
    fi

    echo "Installing $plugin..."

    TMP_DIR="/tmp/plugin-$plugin"
    rm -rf "$TMP_DIR"
    mkdir -p "$TMP_DIR"

    cd "$TMP_DIR" || exit

    wget -q "$URL" -O plugin.zip
    unzip -q plugin.zip

    echo "Copying plugin files..."

    cp -r ./* "$SERVER_DIR/" 2>/dev/null || true

    cd /tmp
    rm -rf "$TMP_DIR"

done

chown -R cs2server:cs2server /home/cs2server/serverfiles

echo "Plugin installation finished."