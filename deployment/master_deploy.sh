#!/bin/bash

# Activate the virtual environment
source ../.venv/bin/activate

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
    mkdir -p "$PROJECT_ROOT/logs"
    nohup python3 flask_server.py > "$PROJECT_ROOT/logs/flask_server_debug.log" 2>&1 &
    sleep 2  # Allow the process to start
    FLASK_PID=$(ps aux | grep "[p]ython3 flask_server.py" | awk '{print $2}')
    if [ -z "$FLASK_PID" ]; then
        echo "❌ Failed to start Flask server!"
        exit 1
    fi
    echo "✅ Flask server running in the background with PID $FLASK_PID"
    echo "logs are available at $PROJECT_ROOT/logs/flask_server_debug.log"
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
        nohup ./deploy_esp_single_mes.sh > "$PROJECT_ROOT/logs/esp_single_debug.log" 2>&1 &
        sleep 2  # Allow the process to start
        ESP_PID=$(ps aux | grep "[d]eploy_esp_single_mes.sh" | awk '{print $2}')
    elif [ "$esp_choice" == "2" ]; then
        read -p "Enter the interval in minutes: " interval
        if [[ ! "$interval" =~ ^[0-9]+$ ]]; then
            echo "❌ Invalid interval. Please enter a positive integer."
            exit 1
        fi
        echo "🔧 Deploying Interval Measurement code with interval: $interval minute(s)..."
        nohup ./deploy_esp_interval.sh "$interval" > "$PROJECT_ROOT/logs/esp_interval_debug.log" 2>&1 &
        sleep 2  # Allow the process to start
        ESP_PID=$(ps aux | grep "[d]eploy_esp_interval.sh" | awk '{print $2}')
    else
        echo "❌ Invalid choice. Exiting."
        exit 1
    fi

    if [ -z "$ESP_PID" ]; then
        echo "❌ Failed to start ESP code deployment!"
        exit 1
    fi

    echo "✅ ESP code deployment running in the background with PID $ESP_PID"
    echo "logs are available at $PROJECT_ROOT/logs/esp_single_debug.log or esp_interval_debug.log"
    echo "----------------------------------------"
}

# Main script execution
print_banner "🚀 Starting deployment Process"

# Step 1: Run Flask server
run_flask_server

# Step 2: Deploy the webpage
cd "$DEPLOY_SRC" || { echo "❌ Failed to navigate to deploy directory"; exit 1; }
deploy_webpage

# Step 3: Deploy ESP code
deploy_esp_code

# Inform the user about the Flask server and ESP code
print_banner "✅ deployment Completed Successfully"
echo "ℹ️ Flask server is running in the background (PID: $FLASK_PID)"
echo "you can kill the process using the following commands:"
echo "kill $FLASK_PID"
echo "ℹ️ ESP code is deploying in the background - check logs for details"
echo "----------------------------------------"
echo "ℹ️ You can access the webpage at: http://localhost:5000"
echo "========================================"