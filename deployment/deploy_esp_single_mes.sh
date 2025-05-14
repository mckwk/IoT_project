#!/bin/bash

source ../.venv/bin/activate
source "$(dirname "$0")/deployment_config.sh"

cd "$ESP_SINGLE_SRC" || { echo "❌ Failed to navigate to project directory"; exit 1; }

echo "🔨 Building the project..."
pio run
if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi
echo "✅ Build successful!"

echo "📤 Uploading code to ESP..."
pio run -v --target upload
if [ $? -ne 0 ]; then
    echo "❌ Upload failed!"
    exit 1
fi
echo "✅ Upload successful!"
pio device monitor -b 115200
