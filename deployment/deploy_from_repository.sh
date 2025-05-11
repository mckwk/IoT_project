#!/bin/bash

# Load configuration
source ../.venv/bin/activate
source "$(dirname "$0")/deployment_config.sh"

# Install git if not installed
if ! command -v git &> /dev/null; then
    echo "git could not be found, installing..."
    sudo apt-get update
    sudo apt-get install -y git
fi

# Clone the repository
echo "Cloning the repository..."
git clone https://github.com/mckwk/IoT_project.git /tmp/iotproject

# Deploy the entire project
echo "Deploying the entire project..."
rsync -av /tmp/iotproject/ "$PROJECT_ROOT"

# Exclude permission change checking 
git config core.fileMode false

# Ensure the deployment folder is executable
echo "Setting execute permissions on the deployment folder..."
chmod +x "$PROJECT_ROOT/deployment"/*.sh

# Clean up
rm -rf /tmp/iotproject

echo "deployment completed successfully."