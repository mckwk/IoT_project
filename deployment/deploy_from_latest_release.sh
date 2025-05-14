#!/bin/bash

source ../.venv/bin/activate
source "$(dirname "$0")/deployment_config.sh"

if ! command -v git &> /dev/null; then
    echo "git could not be found, installing..."
    sudo apt-get update
    sudo apt-get install -y git
fi

if ! command -v jq &> /dev/null; then
    echo "jq could not be found, installing..."
    sudo apt-get update
    sudo apt-get install -y jq
fi

LATEST_RELEASE_URL=$(curl -s https://api.github.com/repos/mckwk/IoT_project/releases/latest | jq -r '.zipball_url')

echo "Downloading the latest release..."
curl -L "$LATEST_RELEASE_URL" -o /tmp/iotproject.zip

echo "Unzipping the release..."
unzip /tmp/iotproject.zip -d /tmp/iotproject

UNZIPPED_DIR=$(find /tmp/iotproject -mindepth 1 -maxdepth 1 -type d)

echo "Deploying the entire project..."
rsync -av "$UNZIPPED_DIR/" "$PROJECT_ROOT"

git config core.fileMode false

echo "Setting execute permissions on the deployment folder..."
chmod +x "$PROJECT_ROOT/deployment"/*.sh

rm -rf /tmp/iotproject /tmp/iotproject.zip
echo "deployment completed successfully."