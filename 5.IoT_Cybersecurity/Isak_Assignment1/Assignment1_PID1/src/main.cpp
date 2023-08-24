#include <arduino.h>
#include <PI_Control.h>
#include <WiFi.h>



const int lightSensePin = 15;
int SenseValue          = 0;
int SP                  = 2500; //Needs to have this as input from some source, maybe PotMeter 
float Kp                = 10;
const int Ki            = 0.1;


//WiFi config
const char* ssid = "IoT_Dev";
const char* password = "goodlife";


unsigned long lastTime = 0;
float iSum        = 0;


Control NewControl(SP, Kp, Ki);


void setup() {
    Serial.begin(115200);
    delay(1000);
    lastTime    = millis();
    


    WiFi.begin(ssid, password);

    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.println("Connecting to WiFi..");
     }
 
    Serial.println("Connected to the WiFi network");
}



void loop(){


  


    unsigned long currentTime   = millis();
    float elapsedTime = (currentTime - lastTime)/1000.0;
    SenseValue = analogRead(lightSensePin);
    

    float error = SP - SenseValue;

    iSum = iSum + error;


    float CV = Kp*error + Ki*iSum;

    CV = constrain(CV, 0, 10000);


    CV = NewControl.Control_P(SenseValue);


    Serial.println("Current Value");
    Serial.println(SenseValue);
    //Serial.println("Proportional");
    //Serial.println(CV);
    
    lastTime = currentTime;
    delay(2000);

}























