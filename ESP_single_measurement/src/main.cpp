#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <DHT.h>
#include "config.h"

// DHT Sensor Setup
#define DHTPIN 5
#define DHTTYPE DHT11
DHT dht(DHTPIN, DHTTYPE);

void goToDeepSleep();

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
    delay(2000);  // Give sensor time to start

    // Read temperature and humidity
    float temperature = dht.readTemperature();
    float humidity = dht.readHumidity();

    if (isnan(temperature) || isnan(humidity)) {
        Serial.println("❌ Sensor reading error!");
        goToDeepSleep();
        return;
    }

    Serial.print("🌡 Temperature: "); Serial.print(temperature); Serial.println(" °C");
    Serial.print("💧 Humidity: "); Serial.print(humidity); Serial.println(" %");

    // Send data to server
    if (WiFi.status() == WL_CONNECTED) {
        WiFiClientSecure client;
	//client.setTrustAnchors(new BearSSL::X509List(root_ca));
	//client.setInsecure();
	client.setFingerprint(SERVER_FINGERPRINT);
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

    // Go to deep sleep to save power
    goToDeepSleep();
}

void goToDeepSleep() {
    Serial.println("💤 Going to deep sleep...");
    ESP.deepSleep(0);  // Sleep indefinitely until reset
}

void loop() {
    // Empty loop - never runs due to deep sleep
}
