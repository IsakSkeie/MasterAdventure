#include <Arduino.h>



const int AI_1 = 15;


const float theta_t = 22;
const float theta_d = 2;
const float Kh = 3.5;
unsigned long CurrentTime;
unsigned long PreviousTime = 0;
float SamplingTime;

float Tenv = 23;
float dot_Tout;
float Tout;

//function declarations
float dot_HeaterSim(float);
float FE(float, float);

//function definitions
float dot_HeaterSim(float u) {
   return (1/theta_t)*(-Tout + (Kh*u + Tenv)); //Implement a delay for u
 }
 
float FE(float dot_x, float x_prev){
  CurrentTime = millis();
  SamplingTime = (CurrentTime - PreviousTime)/10000;
  float x = x_prev + SamplingTime*dot_x;
  return x;
}




void setup() {
  Serial.begin(115200);
  Serial.println("Input Voltage, Output Temp");
  Tout = Tenv;
  CurrentTime = millis();
  float result = dot_HeaterSim(3);

  
 }

 void loop() {
   

  float cv =  analogRead(AI_1);
  cv = (5-0)*(cv - 200)/(4200-200) + 0;

  dot_Tout = dot_HeaterSim(cv);
  Tout = FE(dot_Tout, Tout);

  Serial.print(cv);
  Serial.print(", ");
  Serial.println(Tout);

 }

 



