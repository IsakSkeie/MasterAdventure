#include <arduino.h>
#include <PI_Control.h>
#include <WiFi.h>
#include <PubSubClient.h>
#include "ThingSpeak.h"
#include "Adafruit_MCP4725.h"



//WiFi Setup
char ssid[] = "Isak sin iPhone";
char pass[] = "244466666";
WiFiClient client;

//ThingSpeak Setup
unsigned long myChannelNumber = 1;
const char * myWriteAPIKey = "UHKJXHGQMJNDV9HD";

int number = 0;

const int AI_1 = 34;
const int AI_2 = 2;
const float T_Max = 35;
#define DAC1 25

int PV_Temp1   = 0;
int PV_Temp2   = 0;
int SP                  = 30; //Needs to have this as input from some source, maybe PotMeter 
float Kp                = 10;
const int Ki            = 0.1;
float pv; 



unsigned long startTime;
unsigned long elapsedTime;
unsigned long currentTime;

//SP step timer
unsigned long SP_CurrentTime;
unsigned long SP_Elapsedtime = 300000;
bool SP_Toggle = true;


//PWM output
const int PWMfreq = 5000;
const int PWMChannel = 0;
const int PWMres = 10;
const int MAX_DUTY_CYCLE = (int)(pow(2, PWMres) - 1);


Control control(SP, 0.4, 0.2);
Adafruit_MCP4725 MCP4725;


void setup() {
    

    Serial.begin(115200);
    delay(1000);
    Serial.println("Temp");
    startTime = millis();
    SP_CurrentTime = millis();
    

    WiFi.mode(WIFI_STA); 
    WiFi.disconnect();  
    ThingSpeak.begin(client);  // Initialize ThingSpeak


    MCP4725.begin(0x60); // The I2C Address of my module 
}



void WifiConnect(){

     // Connect or reconnect to WiFi
    Serial.print("Attempting to connect to SSID: ");
    Serial.println(ssid);
    while(WiFi.status() != WL_CONNECTED){
      WiFi.begin(ssid, pass); // Connect to WPA/WPA2 network. Change this line if using open or WEP network
      Serial.print(".");
      delay(5000);     
    } 
    Serial.println("\nConnected.");
  
} 

void WiFiScan(){


    Serial.println("scan start");

  // WiFi.scanNetworks will return the number of networks found
  int n = WiFi.scanNetworks();
  Serial.println("scan done");
  if (n == 0) {
      Serial.println("no networks found");
  } else {
    Serial.print(n);
    Serial.println(" networks found");
    for (int i = 0; i < n; ++i) {
      // Print SSID and RSSI for each network found
      Serial.print(i + 1);
      Serial.print(": ");
      Serial.print(WiFi.SSID(i));
      Serial.print(" (");
      Serial.print(WiFi.RSSI(i));
      Serial.print(")");
      Serial.println((WiFi.encryptionType(i) == WIFI_AUTH_OPEN)?" ":"*");
      delay(10);
    }
  }
  Serial.println("");

  // Wait a bit before scanning again
  delay(5000);
}


void ThingSpeakWrite(float x){
    int y = ThingSpeak.writeField(myChannelNumber, 1, x, myWriteAPIKey);
    if (y == 200){
        Serial.println("Channel update succesful");

    }
    else{
        Serial.println("Problem updateing channel. HTTP error code " + String(y));
    }

    //Change the value
    number++;
    if(number > 99){
        number = 0;
    }
    delay(20000); // Wait 20 seconds to update the channel again
}



void DAC(float cv){
  uint32_t MCP4725_value;
  int adcInput = 0;
  float voltageIn = 0; 
  float MCP4725_reading;
 
 
  MCP4725_reading = (3.3/4096.0) * cv; //3.3 is your supply voltage
  MCP4725.setVoltage(cv, false);
  delay(250);
  adcInput = analogRead(33); //module output connect to A0
  voltageIn = (adcInput  )/ 1024.0; 


      
}


void loop(){

    //WiFiScan();

    if (WiFi.status() != WL_CONNECTED){
        WifiConnect();
    }

    
    control.CutOff = 500; //Declare cutoff freq
    float cv = 0;

    currentTime = millis();
    elapsedTime = currentTime - startTime;
    //ledcWrite(PWMChannel, 500);
    


    pv = analogRead(AI_1);

    PV_Temp1 = control.LPF(pv);
    

    pv = T_Max*(pv/4050.0);

    //Input calculation
    cv = control.Control_PI(pv);
    Serial.println(cv);
    cv = 255*(cv/3.3);
    if (cv > 254){
      cv = 255;
    }

    dacWrite(DAC1, cv);


    if (elapsedTime < 2500){ //Log data for a few seconds on startup

   
    //Serial.println(pv);

    }
    else if (true)
    {

        //Publish data
        // Write to ThingSpeak. There are up to 8 fields in a channel, allowing you to store up to 8 different
        //int x = ThingSpeak.writeField(myChannelNumber, 1, number, myWriteAPIKey);
        ThingSpeak.setField(1, SP);
        ThingSpeak.setField(2, pv);
        ThingSpeak.setField(3, cv);

        int x = ThingSpeak.writeFields(myChannelNumber, myWriteAPIKey);

        if(x == 200){
          Serial.println("Channel update successful.");
        }
    else{
      Serial.println("Problem updating channel. HTTP error code " + String(x));
        }
  
      delay(10000); // Wait 20 seconds to update the channel again

    }

  delay(2000);




  SP_CurrentTime = millis();

  if (millis() > SP_Elapsedtime){
    SP_Elapsedtime = SP_Elapsedtime + millis();
    SP_Toggle = not SP_Toggle;
  }

  if (millis() > 180000){
    SP = 25;
  }
  else{
    SP = 30;
  }

  control.SP = SP;


  
}



















