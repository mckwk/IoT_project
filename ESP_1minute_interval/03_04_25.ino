#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <WiFiClientSecure.h>
#include <DHT.h>

// DHT Sensor Setup
#define DHTPIN 5
#define DHTTYPE DHT11
DHT dht(DHTPIN, DHTTYPE);

// WiFi Configuration
const char* ssid = "VOTRE_SSID";
const char* password = "VOTRE_MOT_DE_PASSE";
const char* serverUrl = "https://votre-serveur/store";  
const char* apiToken = "VOTRE_API_TOKEN";  // Token sécurisé pour authentification

// Certificat du serveur (ajoutez votre certificat PEM ici)
const char* serverCert = R"EOF(
-----BEGIN CERTIFICATE-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAv8...
-----END CERTIFICATE-----
)EOF";

WiFiClientSecure client;

// Fonction de connexion WiFi robuste
void connectWiFi() {
    WiFi.mode(WIFI_STA);
    WiFi.begin(ssid, password);
    Serial.print("Connexion au WiFi ");
    
    int attempts = 0;
    while (WiFi.status() != WL_CONNECTED && attempts < 10) {
        delay(2000);
        Serial.print(".");
        attempts++;
    }

    if (WiFi.status() == WL_CONNECTED) {
        Serial.println("\n✅ WiFi connecté!");
        Serial.print("IP: ");
        Serial.println(WiFi.localIP());
    } else {
        Serial.println("\n🚨 Échec de connexion au WiFi. Redémarrage...");
        ESP.restart();
    }
}

void setup() {
    Serial.begin(115200);
    Serial.println("Démarrage...");
    
    connectWiFi();
    dht.begin();

    // Charger le certificat du serveur pour sécuriser TLS
    client.setCACert(serverCert);
}

void sendData() {
    float temperature = dht.readTemperature();
    float humidity = dht.readHumidity();

    if (isnan(temperature) || isnan(humidity)) {
        Serial.println("❌ Erreur de lecture du capteur!");
        return;
    }

    Serial.print("🌡 Température: "); Serial.print(temperature); Serial.println(" °C");
    Serial.print("💧 Humidité: "); Serial.print(humidity); Serial.println(" %");

    if (WiFi.status() == WL_CONNECTED) {
        HTTPClient https;

        if (https.begin(client, serverUrl)) {
            https.addHeader("Content-Type", "application/json");
            https.addHeader("Authorization", String("Bearer ") + apiToken);

            String jsonPayload = "{\"temperature\": " + String(temperature) + 
                                 ", \"humidity\": " + String(humidity) + "}";

            int httpResponseCode = https.POST(jsonPayload);

            // ✅ Gestion des erreurs HTTP
            if (httpResponseCode > 0) {
                Serial.print("📡 Réponse HTTPS: ");
                Serial.println(httpResponseCode);

                if (httpResponseCode == 200) {
                    Serial.println("✅ Données envoyées avec succès !");
                } else if (httpResponseCode == 400) {
                    Serial.println("❌ Erreur 400: Mauvaise requête. Vérifiez le JSON.");
                } else if (httpResponseCode == 401) {
                    Serial.println("🚨 Erreur 401: Non autorisé. Vérifiez le Token API.");
                } else if (httpResponseCode == 403) {
                    Serial.println("🚫 Erreur 403: Accès refusé.");
                } else if (httpResponseCode == 404) {
                    Serial.println("🔍 Erreur 404: URL incorrecte.");
                } else if (httpResponseCode >= 500) {
                    Serial.println("🛑 Erreur serveur. Réessayez plus tard.");
                }
            } else {
                Serial.print("⚠️ Erreur d’envoi HTTP: ");
                Serial.println(httpResponseCode);
            }

            https.end();
        } else {
            Serial.println("🚨 Connexion au serveur échouée.");
        }
    } else {
        Serial.println("⚠️ WiFi déconnecté! Reconnexion...");
        connectWiFi();
    }
}


void loop() {
    sendData();
    delay(60000); // Envoi toutes les 60 secondes
}
