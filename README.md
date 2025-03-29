# IoT Project

This project consists of an IoT system that collects temperature and humidity data using ESP8266/ESP32 microcontrollers and displays the data on a web dashboard. The data is stored in a PostgreSQL database and managed via a Flask server.

## Project Structure

- `ESP_interval`: Contains the code for the ESP8266 microcontroller to read sensor data at a configurable interval and send it to the server.
- `ESP_single_measurement`: Contains the code for the ESP32 microcontroller to read sensor data once and send it to the server.
- `Website`: Contains the PHP files for the web dashboard and user authentication.
- `Flask`: Contains the Flask server code to handle data storage and user management.
- `DB`: Contains database user configuration.
- `Deployment`: Contains scripts to automate the deployment process for the project.

## Using Template Configuration Files

To avoid confusion when cloning the repository, sensitive configuration files have been renamed to templates. You need to create actual configuration files from these templates before running the project. Follow these steps:

### Flask Configuration

1. Navigate to the `Flask` directory:
    ```sh
    cd Flask
    ```

2. Copy the `config.template.py` file to `config.py`:
    ```sh
    cp config.template.py config.py
    ```

3. Open `config.py` and update the `DATABASE_URL` with your PostgreSQL connection string.

### Website Configuration

1. Navigate to the `Website` directory:
    ```sh
    cd Website
    ```

2. Copy the `db.template.php` file to `db.php`:
    ```sh
    cp db.template.php db.php
    ```

3. Open `db.php` and update the database connection details (`host`, `port`, `dbname`, `user`, `password`) with your PostgreSQL credentials.

### ESP8266/ESP32 Configuration

1. For the `ESP_single_measurement` project:
    - Navigate to the `ESP_single_measurement/src` directory:
        ```sh
        cd ESP_single_measurement/src
        ```
    - Copy the `config.template.h` file to `config.h`:
        ```sh
        cp config.template.h config.h
        ```
    - Open `config.h` and update the `ssid`, `password`, and `serverUrl` with your WiFi credentials and Flask server URL.

2. For the `ESP_interval` project:
    - Navigate to the `ESP_interval/src` directory:
        ```sh
        cd ESP_interval/src
        ```
    - Copy the `config.template.h` file to `config.h`:
        ```sh
        cp config.template.h config.h
        ```
    - Open `config.h` and update the `ssid`, `password`, and `serverUrl` with your WiFi credentials and Flask server URL.

### Deployment Configuration

1. Navigate to the `Deployment` directory:
    ```sh
    cd Deployment
    ```

2. Copy the `deployment_config.template.sh` file to `deployment_config.sh`:
    ```sh
    cp deployment_config.template.sh deployment_config.sh
    ```

3. Open `deployment_config.sh` and update the paths (`PROJECT_ROOT`, `FLASK_DEST`, `WEBSITE_DEST`, etc.) to match your deployment environment.

## Deployment Instructions on RPI

The `Deployment` folder contains scripts to automate the deployment process for the project. Below are the instructions for using these scripts:

### Scripts for pulling data from the repository to the RPI

#### Deploying from the Repository

To deploy the project from the latest repository contents:
1. Run the script:
    ```sh
    ./Deployment/deploy_from_repository.sh
    ```

#### Deploying from the Latest Release
Use that one if you broke everything and you want to return to a baseline functional version.

To deploy the project from the latest GitHub release:
1. Run the script:
    ```sh
    ./Deployment/deploy_from_latest_release.sh
    ```

### Scripts for deploying the project and running it directly from RPI

### Master Deployment Script

The `master_deploy.sh` script orchestrates the deployment of the Flask server, website, and ESP code.

1. Run the script:
    ```sh
    ./Deployment/master_deploy.sh
    ```

2. Follow the on-screen prompts to:
   - Start the Flask server.
   - Deploy the website.
   - Choose and deploy the ESP code (either single measurement or interval measurement).

### Deploying ESP Interval Code

To deploy the ESP interval measurement code with a custom interval:
1. Run the script:
    ```sh
    ./Deployment/deploy_esp_interval.sh <interval_in_minutes>
    ```
2. Replace `<interval_in_minutes>` with the desired interval in minutes.

### Deploying ESP Single Measurement Code

To deploy the ESP single measurement code:
1. Run the script:
    ```sh
    ./Deployment/deploy_esp_single_mes.sh
    ```

### Deploying the Website

To deploy the website files:
1. Run the script:
    ```sh
    ./Deployment/deploy_web_page.sh
    ```

## Notes

- Logs for the Flask server and ESP deployment are stored in the `Logs` directory.
- The website can be accessed at `http://<your-raspberry-pi-ip>` (or localhost) after deployment.
