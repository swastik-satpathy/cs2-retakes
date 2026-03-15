#!/bin/bash

set -e

SERVER=$1

if [ -z "$SERVER" ]; then
  echo "Usage: ./deploy.sh user@server-ip"
  exit 1
fi

echo "Deploying installer to $SERVER"

ssh $SERVER << 'EOF'

apt update
apt install -y git curl jq unzip

rm -rf cs2-retakes-installer
git clone https://github.com/swastik-satpathy/cs2-server-manager

cd cs2-retakes-installer
sudo bash install.sh

EOF