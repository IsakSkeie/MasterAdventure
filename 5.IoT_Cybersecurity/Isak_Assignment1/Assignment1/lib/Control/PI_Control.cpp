#include "PI_Control.h"
#include <arduino.h>



Control::Control(float SP, float Kp, float Ki) 
{

    _SP         = SP;
    _Kp         = Kp;
    _Ki         = Ki;
    _lastTime   = millis();
    _iSum       = 0;
}

float Control::Control_P(float PV) 
{

    //CV = constrain(CV, 0, 10000);
    error = _SP - PV; //Should have control based on derv
    CV    = error*_Kp;
    return CV;
}

float Control::Control_PI(float PV)
{
    unsigned long currentTime   = millis();
    float elapsedTime = (currentTime - _lastTime)/1000.0;
    error = _SP - PV;

    _iSum = _iSum + error;

    CV = _Kp*error + _Ki*_iSum;
    //CV = constrain(CV, 0, 10000);
    _lastTime = currentTime;
    return CV;
}