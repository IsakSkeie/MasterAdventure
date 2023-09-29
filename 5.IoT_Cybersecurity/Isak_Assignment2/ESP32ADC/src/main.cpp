#include <Arduino.h>
#include <Wire.h>
#include <PubSubClient.h>
#include <WiFi.h>
#include <PI_Control.h>


int ThermistorPin = 34;
int Vo;
float R1 = 10000;
float logR2, R2, T;
float c1 = 1.009249522e-03, c2 = 2.378405444e-04, c3 = 2.019202697e-07;
unsigned long ElapsedTime = 0;


Control control(0, 0.4, 0.2);




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
}


void loop() {



  Vo = analogRead(ThermistorPin);

  T = ThermistorRead(Vo);
  float T_filter = control.LPF(T);
  
  if (millis() > ElapsedTime)
  {
    Serial.println(T);
    ElapsedTime = ElapsedTime + 1000;
  }
  
  

}