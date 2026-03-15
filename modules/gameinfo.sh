#!/bin/bash

echo "Configuring gameinfo.gi..."

GAMEINFO="/home/cs2server/serverfiles/game/csgo/gameinfo.gi"

if grep -q "csgo/addons/metamod" "$GAMEINFO"; then
    echo "Metamod already configured in gameinfo.gi"
    return
fi

sed -i '/Game_LowViolence csgo_lv/a\ \ \ \ Game csgo/addons/metamod' "$GAMEINFO"

echo "Metamod entry added to gameinfo.gi"