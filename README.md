# IoT Project

This project consists of an IoT system that collects temperature and humidity data using ESP8266/ESP32 microcontrollers and displays the data on a web dashboard. The data is stored in a PostgreSQL database and managed via a Flask server.

## Project Structure

- `ESP_1minute_interval`: Contains the code for the ESP8266 microcontroller to read sensor data every minute and send it to the server.
- `ESP_single_measurement`: Contains the code for the ESP32 microcontroller to read sensor data once and send it to the server.
- `Website`: Contains the PHP files for the web dashboard and user authentication.
- `Flask`: Contains the Flask server code to handle data storage and user management.
- `DB`: Contains database user configuration.
- `deploy.sh`: Script to deploy the project on a Raspberry Pi.

## Setup Instructions

### Prerequisites

- Raspberry Pi with Raspbian OS
- PostgreSQL database
- Python 3 and Flask
- PHP and a web server (e.g., Apache)
- Git

### Flask Server Setup

1. Clone the repository:
    ```sh
    git clone https://github.com/mckwk/IoT_project.git /tmp/iotproject
    ```

2. Navigate to the Flask directory:
    ```sh
    cd /tmp/iotproject/Flask
    ```

3. Install the required Python packages:
    ```sh
    pip install -r requirements.txt
    ```

4. Set the `DATABASE_URL` environment variable in `config.py` with your PostgreSQL connection string.

5. Run the Flask server:
    ```sh
    python Flask_server.py
    ```

### Website Setup

1. Copy the contents of the `Website` directory to your web server's root directory, excluding `db.php`:
    ```sh
    sudo rsync -av --exclude='db.php' /tmp/iotproject/Website/ /var/www/html
    ```

2. Update the database connection details in `db.php`.

### ESP8266/ESP32 Setup

1. Update the WiFi credentials and server URL in the `config.h` files in `ESP_1minute_interval` and/or `ESP_single_measurement`.
2. Upload the code to your ESP8266 microcontroller using the Arduino IDE or PlatformIO in VSC.

### Deployment

Run the `deploy.sh` in Deployment folder script to automate the deployment process for current contents of the repo:
```sh
./deploy.sh
```

Run the `deploy.sh` in Deployment folder script to automate the deployment process for the latest release:
```sh
./deploy_release.sh
```
