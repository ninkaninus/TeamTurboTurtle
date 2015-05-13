__author__ = 'StjerneIdioten'
import time
import serial

# configure the serial connections (the parameters differs on the device you are connecting to)
while 1:
    print("Input the serial port" +
          '\r\n(Type "exit" to leave the application)')
    inputReceived = input(">> ")

    if inputReceived in ['Exit','exit']:
        exit()

    try:
        ser = serial.Serial(
        port=inputReceived,
        baudrate=9600,
        parity=serial.PARITY_NONE,
        stopbits=serial.STOPBITS_ONE,
        bytesize=serial.EIGHTBITS
        )
        break
    except serial.SerialException :
        print("Could not open serial connection")

while 1:







