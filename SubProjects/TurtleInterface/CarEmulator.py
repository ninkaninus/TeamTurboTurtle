__author__ = 'StjerneIdioten'
import time
import serial
import random

# configure the serial connections (the parameters differs on the device you are connecting to)

serialObject = serial.Serial()
serialObject.baudrate = 9600
serialObject.parity = serial.PARITY_NONE
serialObject.stopbits = serial.STOPBITS_ONE
serialObject.bytesize = serial.EIGHTBITS
serialObject.timeout = None

while 1:
    print("Input the serial port" +
          '\r\n(Type "exit" to leave the application)')
    inputReceived = input(">> ")

    if inputReceived in ['Exit','exit']:
        exit()

    try:
        serialObject.port = inputReceived
        serialObject.open()
        break
    except serial.SerialException :
        print("Could not open serial connection")

while 1:
    data = serialObject.read(3)
    comType = hex(data[0])
    comCommand = hex(data[1])
    comParameter = data[2]

    #If it is a get type
    if(comType == '0xaa'):
        comType = '\xBB'
        comCommand = random.randint(0,255)
        comParameter = random.randint(0,255)
        serialObject.write(bytearray([ord('\xBB'),comCommand, comParameter]))
        print("Returned %d" %comParameter)

    #If it is a set type
    elif(comType == '0x55'):
        if(comCommand == '0x10'):
            print('Car started with %d%% speed!' %comParameter)
        elif(comCommand == '0x11'):
            print('Car stopped!')







