#!/bin/bash

stop_esp_code() {
    source ../.venv/bin/activate
    echo "🔄 Uploading blank firmware to stop the ESP device..."
    cd /home/rpi/IoT_project/ESP_blank_firmware || { echo "❌ Failed to navigate to blank firmware directory"; exit 1; }
    pio run --target upload
    if [ $? -eq 0 ]; then
        echo "✅ Blank firmware uploaded successfully. ESP device stopped."
    else
        echo "❌ Failed to upload blank firmware. Ensure the ESP device is connected and accessible."
    fi
}

stop_esp_code