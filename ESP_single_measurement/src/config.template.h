#ifndef CONFIG_H
#define CONFIG_H
#define SERVER_FINGERPRINT "fingerprint"
// WiFi Configuration
const char* ssid = "ssid";  // Replace with your WiFi SSID
const char* password = "pwd";         // Replace with your WiFi password
const char* serverUrl = "http://rpi_ip:port/store";  // Raspberry Pi server

const char* root_ca = "cert"; // Replace with your root CA certificate

#endif // CONFIG_H