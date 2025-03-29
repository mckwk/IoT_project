#!/bin/bash

# Load configuration
source "$(dirname "$0")/deployment_config.sh"

# Install git if not installed
if ! command -v git &> /dev/null; then
    echo "git could not be found, installing..."
    sudo apt-get update
    sudo apt-get install -y git
fi

# Clone the repository
git clone https://github.com/mckwk/IoT_project.git /tmp/iotproject

# Deploy the Flask folder, excluding config.py
echo "Deploying Flask folder..."
rsync -av --exclude="config.py" /tmp/iotproject/Flask/ "$FLASK_DEST"

# Deploy the Website folder contents directly to /var/www/html, excluding db.php
echo "Deploying Website folder contents..."
sudo rsync -av --exclude="db.php" /tmp/iotproject/Website/ "$WEBSITE_DEST"

# Deploy the ESP_interval folder, excluding src/config.h
echo "Deploying ESP_interval folder..."
rsync -av --exclude="src/config.h" /tmp/iotproject/ESP_interval/ "$ESP_INTERVAL_SRC"

# Deploy the ESP_single_measurement folder, excluding src/config.h
echo "Deploying ESP_single_measurement folder..."
rsync -av --exclude="src/config.h" /tmp/iotproject/ESP_single_measurement/ "$ESP_SINGLE_SRC"

# Deploy the Deployment folder, excluding deployment_config.sh
echo "Deploying Deployment folder..."
rsync -av --exclude="deployment_config.sh" /tmp/iotproject/Deployment/ "$DEPLOY_SRC"

# Clean up
rm -rf /tmp/iotproject

echo "Deployment completed successfully."