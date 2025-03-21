#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <WiFiClientSecure.h>
#include <DHT.h>

// DHT Sensor Setup
#define DHTPIN 5
#define DHTTYPE DHT11
DHT dht(DHTPIN, DHTTYPE);

// WiFi Configuration
const char* ssid = "ssid";  // Replace with your WiFi SSID
const char* password = "pwd";         // Replace with your WiFi password
const char* serverUrl = "http://rpi_ip:port/store";  // Raspberry Pi server
const char* serverCert = ""; // Server SSL certificate 

WiFiClientSecure client;

void connectWiFi() {
    WiFi.mode(WIFI_STA);
    WiFi.begin(ssid, password);
    unsigned long startAttemptTime = millis();
    while (WiFi.status() != WL_CONNECTED && millis() - StartAttemptTime < 15000) {
        delay(500);
        Serial.print(".");
    }
    if (WiFi.status() == WL_CONNECTED) {
        Serial.println("Connected to WiFi!");
        Serial.print("IP Address: ");
        Serial.println(WiFi.localIP());
    } else {
        Serial.println("Connection failed, retrying...");
        retryWifiConnection();
    }
}

void retryWifiConnection() {
    int retries = 0;
    while (retries<5) {
        Serial.print("Reconnecting to WiFi... Attempt");
        Serial.println(retries+1);
        WiFi.disconnect();
        WiFi.begin(ssid, password);
        unsigned long startAttemptTime = millis();
        while (WiFi.status() != WL_CONNECTED && millis() - startAttemptTime < 10000) {
            delay(500);
            Serial.print(".");
        }
        if (WiFi.status() == WL_CONNECTED) {
            Serial.println("\n Reconnected to WiFi!");
            Serial.print("IP Address: ");
            Serial.println(WiFi.localIP());
            return;
        }
        retries++;
        delay(2000);
    }
    Serial.println("WiFi connection failed after 5 attempts.");
    ESP.restart();        
}

void setup() {
    Serial.begin(115200);
    Serial.println("Initializing WiFi");
    connectWiFi();
    dht.begin();

    client.setCACert(serverCert); //Charger le certificat du serveur
}

void loop() {
    // Read temperature and humidity
    float temperature = dht.readTemperature();
    float humidity = dht.readHumidity();

    if (isnan(temperature) || isnan(humidity)) {
        Serial.println("❌ Sensor reading error!");
        return;
    }

    Serial.print("🌡 Temperature: "); Serial.print(temperature); Serial.println(" °C");
    Serial.print("💧 Humidity: "); Serial.print(humidity); Serial.println(" %");

    // Send data to server
    if (WiFi.status() == WL_CONNECTED) {
                
        HTTPClient https;
        if (https.begin(client, serverUrl)) {
            https.addHeader("Content-Type", "application/json");

            String jsonPayload = "{\"temperature\": " + String(temperature) + ", \"humidity\": " + String(humidity) + "}";
            int httpsResponseCode = https.POST(jsonPayload);
            
            Serial.print("📡 HTTPS Response code: ");
            Serial.println(httpsResponseCode);
            https.end();
        } else {
            Serial.println("Server connection failed!");
        }
    } else {
        Serial.println("🚨 WiFi disconnected!");
        connectWiFi();
    }
    delay(60000); // Wait for 1 minute before next reading
}
