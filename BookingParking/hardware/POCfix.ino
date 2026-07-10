#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <ESP32Servo.h>
#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <PubSubClient.h>
#include <ArduinoJson.h>
#include <time.h>
#include "secrets.h"

// ===== BLE =====
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

//================= MQTT =================
const char* mqttServer   = MQTT_SERVER;
const int mqttPort       = MQTT_PORT;
const char* mqttUser     = MQTT_USER;
const char* mqttPassword = MQTT_PASSWORD;

const char* topicCommand = "flap/01/command"; // server -> flap (ESP32 subscribe)
const char* topicStatus  = "flap/01/status";  // flap -> server (ESP32 publish)

WiFiClientSecure espClient;
PubSubClient mqttClient(espClient);

char mqttClientId[32];

//================= NTP (biar lastSeen beneran Unix epoch sesuai kontrak) =================
const char* ntpServer         = "pool.ntp.org";
const long  gmtOffsetSec      = 7 * 3600;  // WIB, UTC+7
const int   daylightOffsetSec = 0;

//================= BLE =================
#define BLE_SERVICE_UUID        "9e5d1b20-6f42-4a9e-9c2e-9b9a9d9e9f00"
#define BLE_STATUS_CHAR_UUID    "9e5d1b21-6f42-4a9e-9c2e-9b9a9d9e9f00"

BLEServer* bleServer = nullptr;
BLECharacteristic* bleStatusChar = nullptr;
bool bleClientConnected = false;

class MyBLEServerCallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer* server) override {
    bleClientConnected = true;
    Serial.println("[BLE] client connect");
  }
  void onDisconnect(BLEServer* server) override {
    bleClientConnected = false;
    Serial.println("[BLE] client disconnect, lanjut advertising lagi");
    BLEDevice::startAdvertising();
  }
};

//================= OLED =================
#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 32
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, -1);

//================= Pin =================
const int trigPin  = 5;
const int echoPin  = 18;
const int servoPin = 13;

//================= Konstanta =================
const float jarakAmbang = 40.0;                 // ambang deteksi mobil (cm), dipakai buat presence aja
const unsigned long intervalStatus    = 2000;   // jaga-jaga kirim presence tiap 2 detik
const unsigned long intervalHeartbeat = 10000;  // lastSeen tiap 10 detik

const int SERVO_DOWN_ANGLE = 90;
const int SERVO_UP_ANGLE   = 0;

//================= Variabel status =================
Servo myServo;

String flapState = "up";   // cuma berubah lewat command dari backend (jalankanCommand)
String presence  = "free"; // berubah otomatis dari sensor ultrasonic

String lastPresenceSent = "";
unsigned long lastStatusSend    = 0;
unsigned long lastHeartbeatSend = 0;

//==================================================
void publishStatus(JsonDocument& doc) {
  char buffer[256];
  size_t n = serializeJson(doc, buffer);
  mqttClient.publish(topicStatus, buffer, n);
}

void kirimFlapState() {
  StaticJsonDocument<64> doc;
  doc["flapState"] = flapState;
  publishStatus(doc);
}

void kirimPresence() {
  StaticJsonDocument<64> doc;
  doc["presence"] = presence;
  publishStatus(doc);
}

void kirimAck(const char* command, const char* msgId) {
  StaticJsonDocument<96> doc;
  doc["ack"] = command;
  if (msgId != nullptr && strlen(msgId) > 0) {
    doc["msgId"] = msgId;
  }
  publishStatus(doc);
}

void kirimHeartbeat() {
  StaticJsonDocument<64> doc;

  time_t now = time(nullptr);
  if (now < 100000) {
    doc["lastSeen"] = (unsigned long)(millis() / 1000);
  } else {
    doc["lastSeen"] = (unsigned long)now;
  }

  publishStatus(doc);
}

//==================================================
void syncTimeNTP() {
  configTime(gmtOffsetSec, daylightOffsetSec, ntpServer);

  Serial.print("[NTP] sinkronisasi waktu");
  time_t now = time(nullptr);
  int retry = 0;
  while (now < 100000 && retry < 20) {
    delay(500);
    Serial.print(".");
    now = time(nullptr);
    retry++;
  }
  Serial.println();

  if (now < 100000) {
    Serial.println("[NTP] gagal sinkron, lastSeen fallback ke millis() (bukan epoch asli)");
  } else {
    Serial.print("[NTP] tersinkron, epoch sekarang: ");
    Serial.println((unsigned long)now);
  }
}

//==================================================
void updateBLEStatus() {
  if (bleStatusChar == nullptr) return;

  bleStatusChar->setValue(flapState.c_str());
  if (bleClientConnected) {
    bleStatusChar->notify();
  }
}

void setupBLE() {
  BLEDevice::init(mqttClientId);

  bleServer = BLEDevice::createServer();
  bleServer->setCallbacks(new MyBLEServerCallbacks());

  BLEService* bleService = bleServer->createService(BLE_SERVICE_UUID);

  bleStatusChar = bleService->createCharacteristic(
      BLE_STATUS_CHAR_UUID,
      BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY
  );
  bleStatusChar->addDescriptor(new BLE2902());
  bleStatusChar->setValue(flapState.c_str());

  bleService->start();

  BLEAdvertising* advertising = BLEDevice::getAdvertising();
  advertising->addServiceUUID(BLE_SERVICE_UUID);
  advertising->setScanResponse(true);
  advertising->setMinPreferred(0x06);
  advertising->setMinPreferred(0x12);

  BLEDevice::startAdvertising();

  Serial.print("[BLE] advertising sebagai: ");
  Serial.println(mqttClientId);
}

//==================================================
// Satu-satunya jalur yang boleh gerakin servo: command dari backend lewat MQTT
//==================================================
void jalankanCommand(const char* command, const char* msgId) {

  Serial.print("[CMD] menjalankan command: ");
  Serial.println(command);

  if (strcmp(command, "drop") == 0) {

    myServo.write(SERVO_DOWN_ANGLE);
    flapState = "down";

  } else if (strcmp(command, "raise") == 0) {

    myServo.write(SERVO_UP_ANGLE);
    flapState = "up";

  } else {
    Serial.println("[CMD] command tidak dikenali, diabaikan");
    return;
  }

  Serial.print("[SERVO] ditulis ke sudut: ");
  Serial.println(flapState == "down" ? SERVO_DOWN_ANGLE : SERVO_UP_ANGLE);

  kirimFlapState();
  kirimAck(command, msgId);
  updateBLEStatus();
}

//==================================================
void callback(char* topic, byte* payload, unsigned int length) {

  Serial.print("[MQTT IN] topic: ");
  Serial.println(topic);

  Serial.print("[MQTT IN] payload: ");
  for (unsigned int i = 0; i < length; i++) {
    Serial.print((char)payload[i]);
  }
  Serial.println();

  if (strcmp(topic, topicCommand) != 0) {
    Serial.println("[MQTT IN] topic tidak cocok, diabaikan");
    return;
  }

  StaticJsonDocument<128> doc;
  DeserializationError err = deserializeJson(doc, payload, length);

  if (err) {
    Serial.print("[MQTT IN] gagal parse JSON: ");
    Serial.println(err.c_str());
    return;
  }

  const char* command = doc["command"];
  const char* msgId    = doc["msgId"] | "";

  if (command == nullptr) {
    Serial.println("[MQTT IN] field 'command' tidak ada di JSON");
    return;
  }

  jalankanCommand(command, msgId);
}

//==================================================
void connectWiFi() {
  if (WiFi.status() == WL_CONNECTED) return;

  Serial.print("[WIFI] menyambung ke ");
  Serial.println(WIFI_SSID);

  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println();
  Serial.print("[WIFI] terhubung, IP: ");
  Serial.println(WiFi.localIP());
}

//==================================================
void reconnectMQTT() {
  while (!mqttClient.connected()) {

    Serial.print("[MQTT] menghubungkan sebagai ");
    Serial.println(mqttClientId);

    if (mqttClient.connect(mqttClientId, mqttUser, mqttPassword)) {

      Serial.println("[MQTT] terhubung");

      mqttClient.subscribe(topicCommand);
      Serial.print("[MQTT] subscribe ke: ");
      Serial.println(topicCommand);

      kirimFlapState();
      kirimPresence();

    } else {
      Serial.print("[MQTT] gagal, state=");
      Serial.print(mqttClient.state());
      Serial.println(" -> coba lagi 5 detik");
      delay(5000);
    }
  }
}

//==================================================
void selfTestServo() {
  Serial.println("[SERVO] self-test mulai...");

  myServo.write(SERVO_DOWN_ANGLE);
  Serial.println("[SERVO] -> DOWN (90)");
  delay(800);

  myServo.write(SERVO_UP_ANGLE);
  Serial.println("[SERVO] -> UP (0)");
  delay(800);

  Serial.println("[SERVO] self-test selesai");
}

//==================================================
float bacaJarak() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);

  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);

  digitalWrite(trigPin, LOW);

  long durasi = pulseIn(echoPin, HIGH, 30000);

  if (durasi == 0) return -1;

  return durasi * 0.0343 / 2.0;
}

//==================================================
void tampilkanOLED(float jarak) {
  display.clearDisplay();

  display.setTextSize(3);
  display.setCursor(0, 0);
  display.println(flapState == "down" ? "DOWN" : "UP");

  display.drawLine(0, 26, SCREEN_WIDTH, 26, SSD1306_WHITE);

  display.setTextSize(1);
  display.setCursor(0, 32);
  display.print("Jarak : ");
  if (jarak < 0) {
    display.println("N/A");
  } else {
    display.print(jarak, 1);
    display.println(" cm");
  }

  display.setCursor(0, 44);
  display.print("Spot  : ");
  display.println(presence == "occupied" ? "FREE" : "OCCUPIED");

  display.setCursor(0, 54);
  display.print("Flap  : ");
  display.println(flapState == "down" ? "down (buka)" : "up (tutup)");

  display.display();
}

//==================================================
void setup() {
  Serial.begin(115200);

  uint64_t chipid = ESP.getEfuseMac();
  snprintf(mqttClientId, sizeof(mqttClientId),
           "ESP32_SmartParking_%04X",
           (uint16_t)(chipid >> 32));

  Wire.begin(21, 22);

  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

  if (!display.begin(SSD1306_SWITCHCAPVCC, 0x3C)) {
    Serial.println("[OLED] gagal init, cek wiring SDA/SCL & alamat I2C (0x3C)");
    while (true);
  }
  display.clearDisplay();
  display.display();

  myServo.setPeriodHertz(50);
  myServo.attach(servoPin, 500, 2400);

  selfTestServo();
  tampilkanOLED(-1);

  myServo.write(SERVO_UP_ANGLE);
  flapState = "up";
  tampilkanOLED(-1);

  connectWiFi();
  syncTimeNTP();

  espClient.setInsecure();

  mqttClient.setServer(mqttServer, mqttPort);
  mqttClient.setKeepAlive(30);
  mqttClient.setSocketTimeout(15);
  mqttClient.setBufferSize(512);
  mqttClient.setCallback(callback);

  reconnectMQTT();

  setupBLE();
}

//==================================================
void loop() {

  if (WiFi.status() != WL_CONNECTED) connectWiFi();
  if (!mqttClient.connected()) reconnectMQTT();

  mqttClient.loop();

  float jarak = bacaJarak();

  presence = (jarak > 0 && jarak < jarakAmbang) ? "occupied" : "free";

  tampilkanOLED(jarak);

  unsigned long now = millis();

  if (presence != lastPresenceSent || (now - lastStatusSend >= intervalStatus)) {
    kirimPresence();
    lastPresenceSent = presence;
    lastStatusSend    = now;
  }

  if (now - lastHeartbeatSend >= intervalHeartbeat) {
    kirimHeartbeat();
    lastHeartbeatSend = now;
  }

  delay(300);
}
