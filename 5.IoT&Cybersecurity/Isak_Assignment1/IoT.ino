
const int lightSensePin = 15;
int SenseValue          = 0;
int SP                  = 2500; //Needs to have this as input from some source, maybe PotMeter 
const int Kp            = 5;
const int Ki            = 0.1;


unsigned long lastTime = 0;
float iSum        = 0;

void setup() {
    Serial.begin(115200);
    delay(1000);
    lastTime    = millis();
    

}


void PiController()
{

}


void loop(){

    unsigned long currentTime   = millis();
    float elapsedTime = (currentTime - lastTime)/1000.0;
    SenseValue = analogRead(lightSensePin);
    float error = SP - SenseValue;

    iSum = iSum + error;


    int CV = Kp*error + Ki*iSum;

    CV = constrain(CV, 0, 10000);


    Serial.println("Current Value");
    Serial.println(SenseValue);
    Serial.println("integral");
    Serial.println(iSum);
    
    lastTime = currentTime;
    delay(1000);

}


















