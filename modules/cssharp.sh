echo "Checking CounterStrikeSharp..."

CSS_PATH="/home/cs2server/serverfiles/game/csgo/addons/counterstrikesharp"

if [ -d "$CSS_PATH" ]; then
    echo "CounterStrikeSharp already installed. Skipping."
    return
fi 

echo "Installing CounterStrikeSharp..."

(
    cd /tmp

    # clean old files so unzip doesn't prompt for existing extracted entries
    rm -rf cssharp.zip addons

    # pick one release artifact (with-runtime preferred) to avoid downloading two archives into one file
    LATEST=$(curl -s https://api.github.com/repos/roflmuffin/CounterStrikeSharp/releases/latest \
     | jq -r '.assets[] | select(.name | test("with-runtime-linux") or test("linux")) | .browser_download_url' \
     | head -n 1)

    echo "Download URL: $LATEST"

    wget -q --show-progress "$LATEST" -O cssharp.zip

    unzip -o -qq cssharp.zip

    cp -r addons /home/cs2server/serverfiles/game/csgo/
)

chown -R cs2server:cs2server /home/cs2server/serverfiles