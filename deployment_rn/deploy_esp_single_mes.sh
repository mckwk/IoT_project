#!/bin/bash

# Load configuration
source "$(dirname "$0")/deployment_config.sh"

# Navigate to the project directory
cd "$ESP_SINGLE_SRC" || { echo "❌ Failed to navigate to project directory"; exit 1; }

# Build the project
echo "🔨 Building the project..."
pio run
if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi
echo "✅ Build successful!"

# Upload the code to the ESP8266
echo "📤 Uploading code to ESP8266..."
pio run --target upload
if [ $? -ne 0 ]; then
    echo "❌ Upload failed!"
    exit 1
fi
echo "✅ Upload successful!"
