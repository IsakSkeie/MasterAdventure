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
float pv;   

unsigned long startTime;
unsigned long elapsedTime;
unsigned long currentTime;

Control control;


void setup() {
    Serial.begin(115200);
    delay(1000);
    Serial.println("Temp_WithLPF");
    startTime = millis();
    control.CutOff = 500; //Declare cutoff freq
    
}










void loop(){


    
    currentTime = millis();
    elapsedTime = currentTime - startTime;

    if (elapsedTime < 2500){

    pv = analogRead(AI_1);

    PV_Temp1 = control.LPF(pv);
    Serial.println(PV_Temp1);
    }

 
   
    
   


}



















