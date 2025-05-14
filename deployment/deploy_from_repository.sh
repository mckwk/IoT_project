#!/bin/bash

source ../.venv/bin/activate
source "$(dirname "$0")/deployment_config.sh"

if ! command -v git &> /dev/null; then
    echo "git could not be found, installing..."
    sudo apt-get update
    sudo apt-get install -y git
fi

echo "Cloning the repository..."
git clone https://github.com/mckwk/IoT_project.git /tmp/iotproject

echo "Deploying the entire project..."
rsync -av /tmp/iotproject/ "$PROJECT_ROOT"

git config core.fileMode false

echo "Setting execute permissions on the deployment folder..."
chmod +x "$PROJECT_ROOT/deployment"/*.sh

rm -rf /tmp/iotproject
echo "deployment completed successfully."