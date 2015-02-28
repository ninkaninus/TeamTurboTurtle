


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
#define DEBOUNCE_TIME 250 //The time in ms used for debouncing the switch.
#define BAUD_RATE 115200  //The baudrate at which the serial communication will take place

//Defines for sensor compensation
#define HALL_HYSTERESE 15  //The hysterese value for the hall sensor. Defines how much we have to go over the ambient reading, to tricker a lap count.

/*****************Variables*******************/

//For laptime calculations
unsigned long firstTime;   // A place to store the first real time the sensor was triggered.
boolean firstLap; // This is to check whether or not this is a trigger from the first lap(If we don't check, then the first serial output would be a weird reading)
unsigned long previousTime;// A place to store the last time the sensor was triggered
unsigned long newTime;// A place to store the latest time the sensor was triggered
long lapTime;//A place to store the calculated lap time
unsigned long firstlapTime; //A place to store time of the first real lap
unsigned long lapCount; //A place to store the number of laps
long bestTime; //A place to store the time of the best lap

//Misc
byte byteRead;// A place to store the read byte
int mode = STARTUP_MODE; //What mode is the timer currently working in
int hallCompensate = 0;  //The value used to compensate for the ambient reading of the hall sensor

/*****************Functions********************/

//This function is automatically run by the arduino at startup
void setup(){
  Serial.begin(BAUD_RATE); // Start the serial at 115200 baud
  pinMode(SENSOR_PIN,INPUT); //Set the defined sensor pin to an input
  Startup();  //Run the startup function
  mode = RAW_MODE; //Automatically sets the mode to raw afther a hard reboot
  hallCompensate = analogRead(SENSOR_PIN); //Set the compensation value to be the current ambient value from the hall sensor
}

void Startup() {
  firstLap = true; //Set that the first lap has not been run yet
  firstlapTime = 0; //Set time for the first lap time (used to calculate total time on all laps)
  lapCount = 0;//Reset the lap counter
  previousTime = millis(); // Get the time at which the arduino started
  Serial.write(12);//Clear the terminal
}

void loop(){
  if(Serial.available()){ //Do this if there is something available in the serial buffer
    ReadSerial();  //Go to the ReadSerial function
  }

  if ((analogRead(SENSOR_PIN)-hallCompensate) >= HALL_HYSTERESE){ //If the value from the hall sensor minus the ambient value, is larger than the hysterese, then count a lap.
    CountLap();  
  }
}

//This function is used to output the laps to the serial and increment the lap counter
void CountLap() {
  newTime = millis(); // Store the time at which the light was blocked
  if (firstLap == true){  //Do this if it is the first lap
    firstTime = newTime; //Store the first time that the car passed the sensor
  }

  if (mode == SERIAL_MODE){
    lapTime = newTime - previousTime; //Calculate the laptime of latest lap
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
    previousTime = newTime; //set the newest time to the last time to be ready to store the new time when it comes
  }

  if (mode == RAW_MODE){
    lapTime = newTime - previousTime; //calcuate the lap time
    if (firstLap == true){
      firstLap = false; //set the bool to true because now the first lap had been run
    }
    if (lapCount > 0){
      Serial.println(lapTime); // print to serial the lap time 
    }
    previousTime = newTime; //set the newest time to the last time to be ready to store the new time when it comes

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
    Serial.println("Press b to se best time");
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
      delay(10);
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

