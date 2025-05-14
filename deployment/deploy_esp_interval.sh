#!/bin/bash

source ../.venv/bin/activate
source "$(dirname "$0")/deployment_config.sh"

if [ -z "$1" ]; then
    echo "❌ Interval not specified. Usage: ./deploy_esp_interval.sh <interval_in_minutes>"
    exit 1
fi

INTERVAL_MINUTES=$1

cd "$ESP_INTERVAL_SRC" || { echo "❌ Failed to navigate to project directory"; exit 1; }

echo "🔧 Setting interval to $INTERVAL_MINUTES minute(s)..."
sed -i "s/^unsigned int intervalMinutes = .*;/unsigned int intervalMinutes = $INTERVAL_MINUTES;/" src/main.cpp

echo "🔨 Building the project..."
pio run
if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi
echo "✅ Build successful!"

echo "📤 Uploading code to ESP..."
pio run --target upload
if [ $? -ne 0 ]; then
    echo "❌ Upload failed!"
    exit 1
fi
echo "✅ Upload successful!"
