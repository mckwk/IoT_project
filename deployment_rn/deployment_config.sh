#!/bin/bash

# Define common paths
PROJECT_ROOT="/home/rpi/IoT_project/"
FLASK_SRC="$PROJECT_ROOT/Flask"
WEBSITE_SRC="$PROJECT_ROOT/Website"
ESP_SINGLE_SRC="$PROJECT_ROOT/ESP_single_measurement"
ESP_INTERVAL_SRC="$PROJECT_ROOT/ESP_interval"
DEPLOY_SRC="$PROJECT_ROOT/Deployment"

# Deployment destinations
FLASK_DEST="/path/to/flask/destination"
WEBSITE_DEST="/path/to/website/destination"

# Other configurations
EXCLUDE_FILES="db.php"