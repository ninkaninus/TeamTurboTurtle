


/********************************************/
/************Team Turbo Turtle***************/
/************Proudly Presents****************/
/*************The Time Taker!****************/
/********************************************/


/****************Includes********************/

#include <EEPROM.h> //Include the EEPROM library

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
#define DEBOUNCE_TIME 250 //This value should be quite low when using the hall sensor. Set it to about 250 for debugging with a switch.
#define BAUD_RATE 115200  //The baudrate at which the serial communication will take place

//Defines for sensor compensation
#define HALL_HYSTERESE 15  //The hysterese value for the hall sensor. Defines how much we have to go over the ambient reading, to tricker a lap count.

//EEPROM memory address specifications
#define BEST_TIME 1  //Best time is a long. So the next 3 addresses are used aswell.

/*****************Variables*******************/

//For laptime calculations
boolean firstLap = true; // This is to check whether or not this is a trigger from the first lap(If we don't check, then the first serial output would be a weird reading)
unsigned long previousTime = 0;// A place to store the last time the sensor was triggered
unsigned long newTime = 0;// A place to store the latest time the sensor was triggered
long lapTime = 0;//A place to store the calculated lap time
unsigned long lapCount = 0; //A place to store the number of laps
unsigned long totalLapTime = 0;
unsigned long bestTime = 0; //A place to store the time of the best lap

//Misc
byte byteRead = 0;// A place to store the read byte
int mode = STARTUP_MODE; //What mode is the timer currently working in
int hallCompensate = 0;  //The value used to compensate for the ambient reading of the hall sensor

/*****************Functions********************/

//This function is automatically run by the arduino at startup
void setup(){
  Serial.begin(BAUD_RATE); // Start the serial at 115200 baud
  pinMode(SENSOR_PIN,INPUT); //Set the defined sensor pin to an input
  mode = RAW_MODE; //Automatically sets the mode to raw afther a hard reboot
  hallCompensate = analogRead(SENSOR_PIN); //Set the compensation value to be the current ambient value from the hall sensor
  bestTime = EEPROMReadlong(BEST_TIME); //Read bestTime from the EEPROM
  Restart();  //Run the Restart function to setup values for the first lap
}

void Restart() {
  firstLap = true; //Set that the first lap has not been run yet
  lapCount = 0;//Reset the lap counter
  totalLapTime = 0; //Reset the total lap time
  hallCompensate = analogRead(SENSOR_PIN); //Set the compensation value to be the current ambient value from the hall sensor
  Serial.write(12);//Clear the terminal
}

void loop(){
  if(Serial.available()){ //Do this if there is something available in the serial buffer
    ReadSerial();  //Go to the ReadSerial function
  }

  if ((analogRead(SENSOR_PIN)-hallCompensate) > HALL_HYSTERESE){ //If the value from the hall sensor minus the ambient value, is larger than the hysterese, then count a lap.
    CountLap();  
  }
}

//This function is used to output the laps to the serial and increment the lap counter
void CountLap() {
  newTime = millis(); // Store the time at which the car passed the sensor
  if (firstLap == true){  //Do this if it is the first lap
    previousTime = newTime; //Store the first time that the car passed the sensor, as the last time.
    firstLap = false;  //The first lap has now been run
    delay(DEBOUNCE_TIME); //delay so we do not track the object more then once
    return;  //No further calculations are necessarry since this was the first lap, so jump out of CountLap.
  }

  lapTime = newTime - previousTime; //Calculate the laptime of latest lap
  totalLapTime += lapTime;

  switch(mode) {
  case SERIAL_MODE:
    Serial.print(String("Lap ") + lapCount + String("\tLap time: ") + lapTime + String(" ms") + String("\tTotal Time: ") + totalLapTime + String(" ms"));
    break;

  case RAW_MODE:
    Serial.print(lapTime); // print to serial the lap time
    break;
  }
    
  previousTime = newTime; //set the newest time to the last time to be ready to store the new time when it comes
  
  if (lapTime < bestTime){ //Run if lapTime is faster then bestTime
    if(mode == SERIAL_MODE) {
      Serial.print("\tNew Best Time!"); 
    }
    bestTime = lapTime;
    EEPROMWriteLong(BEST_TIME,lapTime); //Write bestTime (lapTime) to the EEPROM
  }
  
  Serial.println();
  
  lapCount ++; //add one to the lap count
  delay(DEBOUNCE_TIME); //delay so we do not track the object more than once  
}

void ReadSerial() {
  byteRead = Serial.read(); // Store the received byte

  switch(byteRead) {
  case BYTE_COMPARE_R:
    Restart();
    break; 

  case BYTE_COMPARE_S:
    mode = SERIAL_MODE;
    break;

  case BYTE_COMPARE_E:
    mode = RAW_MODE;
    break;

  case BYTE_COMPARE_C:
    bestTime = (unsigned long)0xFFFFFFFF;
    EEPROMWriteLong(BEST_TIME, bestTime); //Write the maximum value to the location in the EEPROM to "reset" the best time.
    Serial.println("Best Time Cleared");
    break;

  case BYTE_COMPARE_B:
    Serial.println(String("Best Time:\t") + (unsigned long)bestTime + String(" ms")); // Serial print "Best Time:"
    break;

  case BYTE_COMPARE_H:
    Serial.println("Press s to read in serial mode");
    Serial.println("Press e to read in external mode");
    Serial.println("Press r to reset data");
    Serial.println("Press b to se best time");
    Serial.println("Press c to clear best time");
    Serial.println("press v to see debug values");
    Serial.println("press h to see help");
    break;

  case BYTE_COMPARE_D:
    Serial.println("Now in debug mode!");
    Serial.println(String("Hall Compensate Value: ") + hallCompensate);
    Serial.println(String("Hall Hysterese Value: ") + HALL_HYSTERESE);
    Serial.println("Press any button to output sensor value: ");
    while(!Serial.available());
    Serial.read();
    while(!Serial.available()) {
      Serial.println(analogRead(SENSOR_PIN) + String("\tPress any button to exit"));
      delay(50);
    }
    ReadSerial();
    Restart();
    break;
  }
}

void EEPROMWriteLong(int address, unsigned long value)
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










