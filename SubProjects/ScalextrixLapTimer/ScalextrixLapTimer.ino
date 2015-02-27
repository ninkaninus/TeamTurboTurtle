

/********************************************/
/************Team Turbo Turtle***************/
/************Proudly Presents****************/
/*************The Time Taker!****************/
/********************************************/


/****************Includes********************/

#include <EEPROM.h> //Include the EEPROM libarary

/*****************Defines********************/

//Define the data output modes
#define STARTUP_MODE 0 //This mode is for when the program is uninitialized, primarily for debugging.
#define RAW_MODE 1 //This mode only sends the laptime over serial. For use with other programs. Outputs the lap time in ms.
#define SERIAL_MODE 2 //This mode is for using an external serial monitor as a display. Displays: Lap #, Lap Time and Total Time. In a human readable and understandable format.

//Define char inputs for serial communication
#define BYTE_COMPARE_R 114 //ASCII value for r
#define BYTE_COMPARE_S 115 //ASCII value for s
#define BYTE_COMPARE_E 101 //ASCII value for e
#define BYTE_COMPARE_H 104 //ASCII value for h
#define BYTE_COMPARE_D 100 //ASCII value for d
#define BYTE_COMPARE_C 99  //ASCII value for c
#define BYTE_COMPARE_B 98  //ASCII value for b

//Defines for I/O
#define SENSOR_PIN A0 //The pin where the button is connected. The program is designed for a button with a pulldown configuration.

//Defines for time constants
#define DEBOUNCE_TIME 250 //The time in ms used for debouncing the switch.
#define BAUD_RATE 115200

//Defines for sensor compensation
#define HALL_HYSTERESE 15

/*****************Variables*******************/

//For laptime calculations
unsigned long firstTime;// a place to store the first real time the sensor war trigged
boolean firstLap; //a bool to hol if the first run has been preformed
unsigned long lastTime;// place to store the last time the sensor war trigged
unsigned long newTime;// place to store the newest time the sensor war trigged
long lapTime;//place to store the calculated lap time
unsigned long firstlapTime; //place to store time of the first real lap
unsigned long lapCount; //place to store the number of laps
long bestTime; //place to store the time of the best lap

//Misc
byte byteRead;// place to store the read byte
int mode = STARTUP_MODE;
int hallCompensate = 0;

/*****************Functions********************/

void setup(){
  Serial.begin(BAUD_RATE); // start the serial at 115200 baud
  pinMode(SENSOR_PIN,INPUT); //set the pin to an input
  Startup();
  mode = RAW_MODE;
  hallCompensate = analogRead(SENSOR_PIN);
}

void Startup() {
  firstLap = true; //set that the first lap has not been run
  firstlapTime = 0; //set time for the first lap time (used to calculate total time on all laps)
  lapCount = 0;//zero the lap counter
  lastTime = millis(); // get the time the arduino started
  Serial.write(12);//Clear the terminal
}

void loop(){
  if(Serial.available()){ //do this if there is something at the serial port
    ReadSerial();
  }

  if ((analogRead(SENSOR_PIN)-hallCompensate) >= HALL_HYSTERESE){ //compare the value to find out if the light is blocked
    CountLap();  
  }
}

void CountLap() {
  newTime = millis(); // store the time the light was blocked
  if (firstLap == true){  //do this if it is the first lap
    firstTime = newTime; //store the first time the light gets blocked
  }

  if (mode == SERIAL_MODE){
    lapTime = newTime - lastTime; //calcuate the lap time
    if (firstLap == true){
      lapTime = firstTime - lapTime;
      firstLap = false; //set the bool to true because now the first lap had been run
    }
    firstlapTime = newTime - firstTime; //calculate the time since the first lap was runned
    if (lapCount > 0){
      String stringOut = "";
      stringOut = String("Lap ") + lapCount + String("\tLap time: ") + lapTime + String("\tTotal Time: ") + firstlapTime;
      Serial.println(stringOut);
    }
    lastTime = newTime; //set the newest time to the last time to be ready to store the new time when it comes
  }

  if (mode == RAW_MODE){
    lapTime = newTime - lastTime; //calcuate the lap time
    if (firstLap == true){
      firstLap = false; //set the bool to true because now the first lap had been run
    }
    if (lapCount > 0){
      Serial.println(lapTime); // print to serial the lap time 
    }
    lastTime = newTime; //set the newest time to the last time to be ready to store the new time when it comes

  }
  bestTime = EEPROMReadlong(1); //Read bestTime from the EEPROM
  if (lapTime < bestTime){ //Run if lapTime is faster then bestTime
    EEPROMWritelong(1,lapTime); //Write bestTime (lapTime) to the EEPROM
  }
  lapCount ++; //add one to the lap count
  delay(DEBOUNCE_TIME); //delay so we do not track the object more then once  
}

void ReadSerial() {
  byteRead = Serial.read(); // store the byte send into the serial

  switch(byteRead) {
  case BYTE_COMPARE_R:
    Startup();
    break; 

  case BYTE_COMPARE_S:
    mode = SERIAL_MODE;
    break;

  case BYTE_COMPARE_E:
    mode = RAW_MODE;
    break;

  case BYTE_COMPARE_C:
    clearEEPROM();
    break;

  case BYTE_COMPARE_B:
    printBestTime();
    break;

  case BYTE_COMPARE_H:
    Serial.println("Press s to read in serial mode");
    Serial.println("Press e to read in external mode");
    Serial.println("Press r to reset data");
    Serial.println("Press c to clear best time");
    Serial.println("press v to see debug values");
    Serial.println("press h to see help");
    break;

  case BYTE_COMPARE_D:
    Serial.println("Now in debug mode!");
    Serial.println(String("Hall Compensate Value: ") + hallCompensate);
    Serial.println(String("Hall Hysterese Value: ") + HALL_HYSTERESE);
    Serial.println("Now outputting hall sensor value: ");
    while(!Serial.available()) {
      Serial.println(analogRead(SENSOR_PIN));
      delay(250);
    }
    ReadSerial();
    Startup();
    break;
  }
}

void EEPROMWritelong(int address, unsigned long value)
{
  //Decomposition from a long to 4 bytes by using bitshift.
  //One = Most significant -> Four = Least significant byte
  byte four = (value & 0xFF);
  byte three = ((value >> 8) & 0xFF);
  byte two = ((value >> 16) & 0xFF);
  byte one = ((value >> 24) & 0xFF);

  //Write the 4 bytes into the eeprom memory.
  EEPROM.write(address, four);
  EEPROM.write(address + 1, three);
  EEPROM.write(address + 2, two);
  EEPROM.write(address + 3, one);
}

long EEPROMReadlong(unsigned long address)
{
  //Read the 4 bytes from the eeprom memory.
  long four = EEPROM.read(address);
  long three = EEPROM.read(address + 1);
  long two = EEPROM.read(address + 2);
  long one = EEPROM.read(address + 3);

  //Return the recomposed long by using bitshift.
  return ((four << 0) & 0xFF) + ((three << 8) & 0xFFFF) + ((two << 16) & 0xFFFFFF) + ((one << 24) & 0xFFFFFFFF);
}

void clearEEPROM(){
  for (int i = 0; i < 512; i++){ // write a 0 to all 512 bytes of the EEPROM
    EEPROM.write(i, 1);
  }
  Serial.println("Best time cleared!"); // Serial print "Best time cleared!"
}

void printBestTime(){
  bestTime = EEPROMReadlong(1);  //Read best time from EEPROM and store in bestTime
  Serial.print("Best Time:\t"); // Serial print "Best Time:"
  Serial.println(bestTime);  // Serial print the value of best Time
}

