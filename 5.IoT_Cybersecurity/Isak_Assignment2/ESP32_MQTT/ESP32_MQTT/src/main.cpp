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



int ThermistorPin = 34;
int Vo;
float R1 = 10000;
float logR2, R2, T;
float c1 = 1.009249522e-03, c2 = 2.378405444e-04, c3 = 2.019202697e-07;
unsigned long ElapsedTime = 0;


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



float ThermistorRead(float Vo)
{
   R2 = R1 * (4050 / (float)Vo - 1.0);
  logR2 = log(R2);
  T = (1.0 / (c1 + c2*logR2 + c3*logR2*logR2*logR2));
  T = T - 273.15;
  return T;
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



    
    Vo = analogRead(ThermistorPin);

    T = ThermistorRead(Vo);
    float T_filter = NewControl.LPF(T);
    char buffer[20];
    sprintf(buffer, "%.2f", T_filter);
    const char *payload = buffer;

    boolean pubResult = client.publish("pv", payload);

    if (pubResult == true) {
        //Serial.println(" Publish successfull!");
        
    };

    Serial.print(T_filter);
    //Serial.println("Proportional");
    //Serial.println(CV);
    
   
    delay(2000);

}



















