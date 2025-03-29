#!/bin/bash

# Load configuration
source "./deployment_config.sh"

# Function to print a banner
print_banner() {
    echo "========================================"
    echo " $1"
    echo "========================================"
}

# Function to run the Flask server
run_flask_server() {
    print_banner "🚀 Starting Flask Server"
    cd "$FLASK_SRC" || { echo "❌ Failed to navigate to Flask directory"; exit 1; }
    mkdir -p "$PROJECT_ROOT/Logs"
    nohup python3 Flask_server.py > "$PROJECT_ROOT/Logs/flask_server_debug.log" 2>&1 &
    FLASK_PID=$!
    echo "✅ Flask server running in the background with PID $FLASK_PID"
    echo "Logs are available at $PROJECT_ROOT/Logs/flask_server_debug.log"
    echo "----------------------------------------"
}

# Function to deploy the webpage
deploy_webpage() {
    print_banner "🌐 Deploying the Webpage"
    ./deploy_web_page.sh
    if [ $? -ne 0 ]; then
        echo "❌ Failed to deploy the webpage!"
        exit 1
    fi
    echo "✅ Webpage deployed successfully!"
    echo "----------------------------------------"
}

# Function to deploy ESP code
deploy_esp_code() {
    print_banner "🤖 Deploying ESP Code"
    echo "1. Single Measurement"
    echo "2. Interval Measurement"
    echo "----------------------------------------"
    read -p "Enter your choice (1 or 2): " esp_choice

    if [ "$esp_choice" == "1" ]; then
        echo "🔧 Deploying Single Measurement code..."
        nohup ./deploy_esp_single_mes.sh > "$PROJECT_ROOT/Logs/esp_single_debug.log" 2>&1 &
        ESP_PID=$!
    elif [ "$esp_choice" == "2" ]; then
        read -p "Enter the interval in minutes: " interval
        if [[ ! "$interval" =~ ^[0-9]+$ ]]; then
            echo "❌ Invalid interval. Please enter a positive integer."
            exit 1
        fi
        echo "🔧 Deploying Interval Measurement code with interval: $interval minute(s)..."
        nohup ./deploy_esp_interval.sh "$interval" > "$PROJECT_ROOT/Logs/esp_interval_debug.log" 2>&1 &
        ESP_PID=$!
    else
        echo "❌ Invalid choice. Exiting."
        exit 1
    fi

    echo "⏳ Waiting for the ESP code upload to finish..."
    wait $ESP_PID  # Wait for the upload process to complete

    if [ $? -eq 0 ]; then
        echo "✅ ESP code upload completed successfully!"
    else
        echo "❌ ESP code upload failed!"
        exit 1
    fi

    echo "----------------------------------------"
}

# Main script execution
print_banner "🚀 Starting Deployment Process"

# Step 1: Run Flask server
run_flask_server

# Step 2: Deploy the webpage
cd "$DEPLOY_SRC" || { echo "❌ Failed to navigate to deploy directory"; exit 1; }
deploy_webpage

# Step 3: Deploy ESP code
deploy_esp_code

# Inform the user about the Flask server and ESP code
print_banner "✅ Deployment Completed Successfully"
echo "ℹ️ Flask server is running in the background (PID: $FLASK_PID)"
echo "ℹ️ ESP code is running in the background (PID: $ESP_PID)"
echo "ℹ️ You can access the webpage at: http://localhost:5000"
echo "========================================"