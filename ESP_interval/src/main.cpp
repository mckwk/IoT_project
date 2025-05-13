#include <WiFi.h>
#include <HTTPClient.h>
#include <DHT.h>
#include "config.h"

// DHT Sensor Setup
#define DHTPIN 5
#define DHTTYPE DHT11
DHT dht(DHTPIN, DHTTYPE);

// User-defined interval in minutes
unsigned int intervalMinutes = 1; // Default interval (can be modified)

void setup() {
    Serial.begin(115200);
    WiFi.begin(ssid, password);

    Serial.print("Connecting to ");
    Serial.println(ssid);

    while (WiFi.status() != WL_CONNECTED) {
        delay(1000);
        Serial.print(".");
    }

    Serial.println("\n✅ Connected to WiFi!");
    Serial.print("IP Address: ");
    Serial.println(WiFi.localIP());

    dht.begin();
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
        WiFiClientSecure client;
        client.setCACert(root_ca);

        if (!client.connect("192.168.0.118", 8443)) {
            Serial.println("Connection failed");
        } else {
            Serial.println("Connected!");
        }

        HTTPClient http;
        if(http.begin(client, serverUrl)) {
        	http.addHeader("Content-Type", "application/json");
		http.addHeader("X-API-KEY", secKey);

        	String jsonPayload = "{\"temperature\": " + String(temperature) + 
                	             ", \"humidity\": " + String(humidity) + "}";

        	int httpResponseCode = http.POST(jsonPayload);
        	Serial.print("📡 HTTP Response code: ");
        	Serial.println(httpResponseCode);

        	http.end();
	} else {
		Serial.println("HTTPS connection failed");
	}    
    } else {
        Serial.println("🚨 WiFi disconnected!");
    }

    // Wait for the user-defined interval before the next reading
    unsigned long intervalMillis = intervalMinutes * 60000; // Convert minutes to milliseconds
    Serial.print("⏳ Waiting for ");
    Serial.print(intervalMinutes);
    Serial.println(" minute(s)...");
    delay(intervalMillis);
}