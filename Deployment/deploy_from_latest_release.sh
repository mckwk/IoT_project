#!/bin/bash

# Load configuration
source "$(dirname "$0")/deployment_config.sh"

# Install git and jq if not installed
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

# Fetch the latest release download URL
LATEST_RELEASE_URL=$(curl -s https://api.github.com/repos/mckwk/IoT_project/releases/latest | jq -r '.zipball_url')

# Download the latest release
echo "Downloading the latest release..."
curl -L "$LATEST_RELEASE_URL" -o /tmp/iotproject.zip

# Unzip the release
echo "Unzipping the release..."
unzip /tmp/iotproject.zip -d /tmp/iotproject

# Find the unzipped directory (it will have a dynamic name)
UNZIPPED_DIR=$(find /tmp/iotproject -mindepth 1 -maxdepth 1 -type d)

# Deploy the entire project
echo "Deploying the entire project..."
rsync -av "$UNZIPPED_DIR/" "$PROJECT_ROOT"

# Exclude permission change checking 
git config core.fileMode false

# Ensure the deployment folder is executable
echo "Setting execute permissions on the deployment folder..."
chmod +x "$PROJECT_ROOT/deployment"/*.sh

# Clean up
rm -rf /tmp/iotproject /tmp/iotproject.zip

echo "deployment completed successfully."