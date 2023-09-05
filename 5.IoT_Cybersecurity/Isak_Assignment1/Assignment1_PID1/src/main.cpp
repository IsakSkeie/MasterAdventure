#include <arduino.h>
#include <PI_Control.h>
#include <WiFi.h>
#include <PubSubClient.h>




const int AI_1 = 15;
const int AI_2 = 2;
int PV_Temp1   = 0;
int PV_Temp2   = 0;
int SP                  = 2500; //Needs to have this as input from some source, maybe PotMeter 
float Kp                = 10;
const int Ki            = 0.1;

void setup() {
    Serial.begin(115200);
    delay(1000);
    Serial.println("Temp, FilteredTemp");
    
}










void loop(){

  



    PV_Temp1 = analogRead(AI_1);
    PV_Temp2 = analogRead(AI_2);
  
    Serial.print(PV_Temp1);
    Serial.print(", ");
    Serial.println(PV_Temp2);
   
    
   
    delay(2000);

}



















