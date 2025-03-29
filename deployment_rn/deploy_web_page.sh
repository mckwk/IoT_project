#!/bin/bash

# Load configuration
source "$(dirname "$0")/deployment_config.sh"

# Ensure the destination directory exists
if [ ! -d "$WEBSITE_DEST" ]; then
    echo "Creating destination directory: $WEBSITE_DEST"
    sudo mkdir -p "$WEBSITE_DEST"
fi

# Copy the contents of the website folder to the destination directory
echo "Copying website files to $WEBSITE_DEST..."
sudo rsync -av --exclude="$EXCLUDE_FILES" "$WEBSITE_SRC/" "$WEBSITE_DEST/"

# Set the correct ownership and permissions
echo "Setting ownership and permissions..."
sudo chown -R www-data:www-data "$WEBSITE_DEST"
sudo chmod -R 755 "$WEBSITE_DEST"
