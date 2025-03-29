# IoT Project

This project consists of an IoT system that collects temperature and humidity data using ESP8266/ESP32 microcontrollers and displays the data on a web dashboard. The data is stored in a PostgreSQL database and managed via a Flask server.

## Project Structure

- `ESP_interval`: Contains the code for the ESP8266 microcontroller to read sensor data at a configurable interval and send it to the server.
- `ESP_single_measurement`: Contains the code for the ESP32 microcontroller to read sensor data once and send it to the server.
- `Website`: Contains the PHP files for the web dashboard and user authentication.
- `Flask`: Contains the Flask server code to handle data storage and user management.
- `DB`: Contains database user configuration.
- `Deployment`: Contains scripts to automate the deployment process for the project.


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
