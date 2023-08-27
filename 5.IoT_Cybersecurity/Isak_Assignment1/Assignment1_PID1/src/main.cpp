#include <arduino.h>
#include <PI_Control.h>
#include <WiFi.h>
#include <PubSubClient.h>




const int lightSensePin = 15;
int SenseValue          = 0;
int SP                  = 2500; //Needs to have this as input from some source, maybe PotMeter 
float Kp                = 10;
const int Ki            = 0.1;


//WiFi config
const char* ssid = "IoT_Dev";
const char* password = "goodlife";
const char* mqtt_server = "192.168.8.235";

unsigned long lastTime = 0;
float iSum        = 0;
long lastMsg = 0;
char msg[50];
int value = 0;

WiFiClient espClient;
PubSubClient client(espClient);
Control NewControl(SP, Kp, Ki);




void callback(char* topic, byte* message, unsigned int length) {
  Serial.print("Message arrived on topic: ");
  Serial.print(topic);
  Serial.print(". Message: ");
  String messageTemp;
  
  for (int i = 0; i < length; i++) {
    Serial.print((char)message[i]);
    messageTemp += (char)message[i];
  }
  Serial.println();

  // Feel free to add more if statements to control more GPIOs with MQTT

  // If a message is received on the topic esp32/output, you check if the message is either "on" or "off". 
  // Changes the output state according to the message
//   if (String(topic) == "esp32/output") {
//     Serial.print("Changing output to ");
//     if(messageTemp == "on"){
//       Serial.println("on");
//       digitalWrite(ledPin, HIGH);
//     }
//     else if(messageTemp == "off"){
//       Serial.println("off");
//       digitalWrite(ledPin, LOW);
//     }
//   }
}


void setup_wifi() {
  delay(10);
  // We start by connecting to a WiFi network
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

void setup() {
    Serial.begin(115200);
    delay(1000);
    lastTime    = millis();
    


    setup_wifi();
    client.setServer(mqtt_server, 1883);
    client.setCallback(callback);
}






void reconnect() {
  // Loop until we're reconnected
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    // Attempt to connect
    if (client.connect("ESP8266Client")) {
      Serial.println("connected");
      // Subscribe
      client.subscribe("esp32/output");
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      // Wait 5 seconds before retrying
      delay(5000);
    }
  }
}



void loop(){

  



    SenseValue = analogRead(lightSensePin);
    

      if (!client.connected()) {
    reconnect();
        }
    client.loop();



    Serial.println("Current Value");
    Serial.println(SenseValue);
    //Serial.println("Proportional");
    //Serial.println(CV);
    
   
    delay(2000);

}



















