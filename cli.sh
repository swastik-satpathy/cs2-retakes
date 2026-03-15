#!/bin/bash

ENV_FILE=".env"

# Load env if exists
if [ -f "$ENV_FILE" ]; then
    echo "Loading configuration from .env"
    set -a
    source "$ENV_FILE"
    set +a
fi

ask_if_empty() {
    VAR=$1
    QUESTION=$2

    if [ -z "${!VAR:-}" ]; then
        read -rp "$QUESTION: " VALUE
        export $VAR="$VALUE"
    fi
}

ask_if_empty GSLT "Steam GSLT Token"
ask_if_empty SERVER_NAME "Server Name"
ask_if_empty SERVER_TAGS "Server Tags"
ask_if_empty OWNER_STEAMID "Owner SteamID"
ask_if_empty ADMINS "Admin SteamIDs (comma separated)"
ask_if_empty WEBHOOK "Discord Webhook URL (optional)"

# Plugin handling
if [ -z "${PLUGINS:-}" ]; then

    echo ""
    echo "Select plugins to install:"
    echo ""

    declare -A PLUGINS_MAP=(
        [retakes]=0
        [allocator]=0
        [instaplant]=0
        [instadefuse]=0
        [rtv]=0
        [clutchannounce]=0
        [simpleadmin]=0
    )

    for plugin in "${!PLUGINS_MAP[@]}"; do
        read -rp "Install $plugin? (y/n): " answer

        if [[ "$answer" =~ ^[Yy]$ ]]; then
            PLUGINS_MAP[$plugin]=1
        fi
    done

    SELECTED_PLUGINS=$(
        for plugin in "${!PLUGINS_MAP[@]}"; do
            if [ "${PLUGINS_MAP[$plugin]}" -eq 1 ]; then
                echo -n "$plugin,"
            fi
        done
    )

    SELECTED_PLUGINS=${SELECTED_PLUGINS%,}

else
    SELECTED_PLUGINS="$PLUGINS"
fi

export SELECTED_PLUGINS