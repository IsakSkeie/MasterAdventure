#include "PI_Control.h"
#include <arduino.h>



Control::Control(float SP, float Kp, float Ki) 
{

    _SP         = SP;
    _Kp         = Kp;
    _Ki         = Ki;
    _PI_lastTime   = millis();
    _PI_iSum       = 0;
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
    float elapsedTime = (currentTime - _PI_lastTime)/1000.0;
    error = _SP - PV;

    _PI_iSum = _PI_iSum + error;

    CV = _Kp*error + _Ki*_PI_iSum;
    //CV = constrain(CV, 0, 10000);
    _PI_lastTime = currentTime;
    return CV;
}

float Control::LPF(float PV)
{
    unsigned long currentTime   = millis();
    float dt = (currentTime - _LPF_lastTime)/1000.0;
    float rc = 1.0/(2.0 * M_PI * CutOff);
    alpha   = dt / (dt + rc);

    _LPF_Output     = (1-alpha)*_LPF_PrevOutput + alpha*PV; 
    _LPF_lastTime   = currentTime;
    _LPF_PrevOutput = _LPF_Output;

    return _LPF_Output
}