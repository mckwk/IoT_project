#!/bin/bash

# Install git if not installed
if ! command -v git &> /dev/null
then
    echo "git could not be found, installing..."
    sudo apt-get update
    sudo apt-get install -y git
fi

# Define the source and destination directories
FLASK_SRC="https://github.com/mckwk/IoT_project/tree/main/Flask"
WEBSITE_SRC="https://github.com/mckwk/IoT_project/tree/main/Website"
FLASK_DEST="/home/rpi/iotproject"
WEBSITE_DEST="/var/www/html"

# Clone the repository
git clone https://github.com/mckwk/IoT_project.git /tmp/iotproject

# Deploy the Flask folder
echo "Deploying Flask folder..."
cp -r /tmp/iotproject/Flask/* $FLASK_DEST

# Deploy the Website folder contents directly to /var/www/html, excluding db.php
echo "Deploying Website folder contents..."
sudo rsync -av --exclude='db.php' /tmp/iotproject/Website/ $WEBSITE_DEST

# Clean up
rm -rf /tmp/iotproject

echo "Deployment completed successfully."