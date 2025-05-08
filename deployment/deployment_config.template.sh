#!/bin/bash

# Define common paths
PROJECT_ROOT="/path/to/project"
FLASK_SRC="$PROJECT_ROOT/flask"
WEBSITE_SRC="$PROJECT_ROOT/website"
ESP_SINGLE_SRC="$PROJECT_ROOT/ESP_single_measurement"
ESP_INTERVAL_SRC="$PROJECT_ROOT/ESP_interval"
DEPLOY_SRC="$PROJECT_ROOT/deployment"

# deployment destination
WEBSITE_DEST="/path/to/website/destination"

# Other configurations
EXCLUDE_FILES="db.php"