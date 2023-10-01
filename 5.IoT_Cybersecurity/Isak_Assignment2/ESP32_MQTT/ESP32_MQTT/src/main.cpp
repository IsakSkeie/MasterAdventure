#include <arduino.h>
#include <PI_Control.h>
#include <WiFi.h>
#include <PubSubClient.h>




const int AI_1 = 15;
const int AI_2 = 18;
int PV_Temp1   = 0;
int PV_Temp2   = 0;
int SP                  = 2500; //Needs to have this as input from some source, maybe PotMeter 
float Kp                = 10;
const int Ki            = 0.1;
const char topic[3]     = "PV"; //topic for MQTT broker


//WiFi config
const char* ssid = "IoT_Dev";
const char* pass = "goodlife";
//const char* mqtt_server = "ssl://7e62ff77398c4f969b8ec2a58b7073e5.s2.eu.hivemq.cloud";
const char* mqtt_server = "192.168.8.107";
const int mqtt_port = 1885;


const char* mqtt_user = "ESP32_Isak";
const char* mqtt_pswd = "ESP32_Isak";


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


void WifiConnect(){

     // Connect or reconnect to WiFi
    Serial.print("Attempting to connect to SSID: ");
    Serial.println(ssid);
    while(WiFi.status() != WL_CONNECTED){
      WiFi.begin(ssid, pass); // Connect to WPA/WPA2 network. Change this line if using open or WEP network
      Serial.print(".");
      delay(5000);     
    } 
    Serial.println("\nConnected.");
  
} 

void setup() {
    Serial.begin(115200);
    delay(1000);
    lastTime    = millis();
    
    client.setServer(mqtt_server, mqtt_port);
    
  
    client.setCallback(callback);
}






void reconnect() {
  // Loop until we're reconnected
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    // Attempt to connect
    if (client.connect("ESP32Client")) {
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

  
    if (WiFi.status() != WL_CONNECTED){
        WifiConnect();
    }

      if (!client.connected()) {
    reconnect();
        }
    client.loop();



    
    char* payload = "10";
    boolean pubResult = client.publish("pv", "TestMessage");

    if (pubResult == true) {
        Serial.println("Publish successfull!");
    };
    //Serial.println("Proportional");
    //Serial.println(CV);
    
   
    delay(2000);

}



















