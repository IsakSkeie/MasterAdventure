#include <Arduino.h>

#define DAC1 25


const int AI_1 = 34;

const float theta_t = 22;
const float T_Max = 35;
const float theta_d = 2;
const float Kh = 3.5;
unsigned long CurrentTime;
unsigned long PreviousTime = 0;
double SamplingTime;

float what is the equivalent of millis in cpp in python
float dot_Tout;
float Tout;



//PWM output
const int PWMfreq = 5000;
const int PWMChannel = 0;
const int PWMres = 10;
const int MAX_DUTY_CYCLE = (int)(pow(2, PWMres) - 1);

//function declarations
float dot_HeaterSim(float);
float FE(float, float);

//function definitions
float dot_HeaterSim(float u) {
   return (1/theta_t)*(-Tout + (Kh*u + Tenv)); //Implement a delay for u
 }
 
float FE(float dot_x, float x_prev){
  CurrentTime = millis();
  SamplingTime = (CurrentTime - PreviousTime)/1000.0;
  

  float x = x_prev + SamplingTime*dot_x;
  
  PreviousTime = CurrentTime;
  return x;
}




void setup() {
  Serial.begin(115200);
  Serial.println("Control Voltage, Output Temp");
  Tout = Tenv;
  CurrentTime = millis();
  
 }

 void loop() {
   

  float cv =  analogRead(AI_1);
  cv = 3.3 * (cv/4050);
  
  
    
  dot_Tout = dot_HeaterSim(cv);
  Tout = FE(dot_Tout, Tout);

  Serial.print(cv);
  Serial.print(", ");
  Serial.println(Tout);
  

  float pv = (255) * Tout/T_Max; 

  dacWrite(DAC1, pv);
  delay(100);
  
 }

 



