#!/bin/bash

source ../.venv/bin/activate
source "$(dirname "$0")/deployment_config.sh"

if [ ! -d "$WEBSITE_DEST" ]; then
    echo "Creating destination directory: $WEBSITE_DEST"
    sudo mkdir -p "$WEBSITE_DEST"
fi

echo "Copying website files to $WEBSITE_DEST..."
sudo rsync -av "$WEBSITE_SRC/" "$WEBSITE_DEST/"

echo "Setting ownership and permissions..."
sudo chown -R www-data:www-data "$WEBSITE_DEST"
sudo chmod -R 755 "$WEBSITE_DEST"
