#!/bin/bash

# Install git and jq if not installed
if ! command -v git &> /dev/null
then
    echo "git could not be found, installing..."
    sudo apt-get update
    sudo apt-get install -y git
fi

if ! command -v jq &> /dev/null
then
    echo "jq could not be found, installing..."
    sudo apt-get update
    sudo apt-get install -y jq
fi

# Define the source and destination directories
FLASK_DEST="/home/rpi/iotproject"
WEBSITE_DEST="/var/www/html"

# Fetch the latest release download URL
LATEST_RELEASE_URL=$(curl -s https://api.github.com/repos/mckwk/IoT_project/releases/latest | jq -r '.zipball_url')

# Download the latest release
echo "Downloading the latest release..."
curl -L $LATEST_RELEASE_URL -o /tmp/iotproject.zip

# Unzip the release
echo "Unzipping the release..."
unzip /tmp/iotproject.zip -d /tmp/iotproject

# Find the unzipped directory (it will have a dynamic name)
UNZIPPED_DIR=$(find /tmp/iotproject -mindepth 1 -maxdepth 1 -type d)

# Deploy the Flask folder
echo "Deploying Flask folder..."
cp -r $UNZIPPED_DIR/Flask/* $FLASK_DEST

# Deploy the Website folder contents directly to /var/www/html, excluding db.php
echo "Deploying Website folder contents..."
sudo rsync -av --exclude='db.php' $UNZIPPED_DIR/Website/ $WEBSITE_DEST

# Clean up
rm -rf /tmp/iotproject /tmp/iotproject.zip

echo "Deployment completed successfully."