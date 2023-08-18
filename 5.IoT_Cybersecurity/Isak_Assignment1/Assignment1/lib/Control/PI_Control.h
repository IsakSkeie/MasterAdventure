
#include <Arduino.h>


class Control {
public:
    //Declared variables that could be useful outside class
    float error;
    float elapsedTime;
    float CV;

    Control(float SP, float Kp, float Ki);
    float Control_P(float PV);
    float Control_PI(float PV);

private:
//Declares var for inputs

    float _SP;
    float _Kp;
    float _Ki;
//Declares variables for scantime based derivative    
    unsigned long _lastTime;
    unsigned long _currentTime;

    float _iSum;
    
};
