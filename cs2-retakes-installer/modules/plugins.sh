# echo "Installing selected plugins..."

# SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# PLUGINS_JSON="$ROOT_DIR/plugins.json"

# if [ ! -f "$PLUGINS_JSON" ]; then
#     echo "plugins.json not found. Skipping plugin installation."
#     return
# fi

# PLUGIN_DIR="/home/cs2server/serverfiles/game/csgo/addons/counterstrikesharp/plugins"

# mkdir -p "$PLUGIN_DIR"

# for plugin in $(jq -r 'keys[]' "$PLUGINS_JSON"); do

#     URL=$(jq -r ".\"$plugin\".url" "$PLUGINS_JSON")

#     if [ "$URL" = "null" ] || [ -z "$URL" ]; then
#         echo "Skipping $plugin (no URL)"
#         continue
#     fi

#     if [ -d "$PLUGIN_DIR/$plugin" ]; then
#         echo "$plugin already installed. Skipping."
#         continue
#     fi

#     echo "Installing $plugin..."

#     cd /tmp
#     wget -q "$URL" -O plugin.zip

#     unzip -o plugin.zip

#     cp -r addons/* /home/cs2server/serverfiles/game/csgo/addons/

# done

# chown -R cs2server:cs2server /home/cs2server/serverfiles


echo "Installing selected plugins..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

PLUGINS_JSON="$ROOT_DIR/plugins.json"

if [ ! -f "$PLUGINS_JSON" ]; then
echo "plugins.json not found. Skipping plugin installation."
return
fi

PLUGIN_DIR="/home/cs2server/serverfiles/game/csgo/addons/counterstrikesharp/plugins"

mkdir -p "$PLUGIN_DIR"

for plugin in $(jq -r 'keys[]' "$PLUGINS_JSON"); do

```
URL=$(jq -r ".\"$plugin\".url" "$PLUGINS_JSON")

if [ "$URL" = "null" ] || [ -z "$URL" ]; then
    echo "Skipping $plugin (no URL)"
    continue
fi

if [ -d "$PLUGIN_DIR/$plugin" ]; then
    echo "$plugin already installed. Skipping."
    continue
fi

echo ""
echo "Processing plugin: $plugin"

DOWNLOAD_URL="$URL"
VERSION="unknown"

########################################
# Test if URL works
########################################

STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$URL")

if [ "$STATUS" != "200" ]; then
    echo "Primary URL returned $STATUS — attempting GitHub latest release lookup..."

    if [[ "$URL" =~ github.com/([^/]+)/([^/]+)/ ]]; then
        OWNER="${BASH_REMATCH[1]}"
        REPO="${BASH_REMATCH[2]}"

        API="https://api.github.com/repos/$OWNER/$REPO/releases/latest"

        VERSION=$(curl -s "$API" | jq -r '.tag_name')

        DOWNLOAD_URL=$(curl -s "$API" | jq -r '.assets[] | select(.name|test("\\.zip$")) | .browser_download_url' | head -n 1)

        if [ "$DOWNLOAD_URL" = "null" ] || [ -z "$DOWNLOAD_URL" ]; then
            echo "Could not find downloadable asset for $plugin"
            continue
        fi

    else
        echo "Non-GitHub URL failed. Skipping $plugin"
        continue
    fi
else
    if [[ "$URL" =~ v[0-9]+\.[0-9]+\.[0-9]+ ]]; then
        VERSION=$(echo "$URL" | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+')
    fi
fi

echo "Downloading $plugin ($VERSION)"

cd /tmp
rm -f plugin.zip

wget -q "$DOWNLOAD_URL" -O plugin.zip

unzip -oq plugin.zip

cp -r addons/* /home/cs2server/serverfiles/game/csgo/addons/
```

done

chown -R cs2server:cs2server /home/cs2server/serverfiles
