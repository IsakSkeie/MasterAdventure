
#include <Arduino.h>


class Control {
public:
    //Declared variables that could be useful outside class
    float error;
    float elapsedTime;
    float CV;
    float alpha; //Filter coefficient
    float CutOff = 1000; //Cut off frequency for LPF
    

    Control(float SP, float Kp, float Ki);
    float Control_P(float PV);
    float Control_PI(float PV);
    float LPF(float PV);

private:
//Declares var for inputs

    float _SP;
    float _Kp;
    float _Ki;
//Declares variables for scantime based derivative    
    unsigned long _PI_lastTime;
    unsigned long _PI_currentTime;
    float _PI_iSum;
    
    float _LPF_PrevOutput;
    float _LPF_Output;
    unsigned long _LPF_lastTime;
    unsigned long _LPF_currentTime;
};
