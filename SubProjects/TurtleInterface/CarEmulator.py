__author__ = 'StjerneIdioten'
import time
import queue
import threading
import serial
import random
from globals import *

def lapTimeEvent():

    lapTime = random.randint(1500, 4500)

    lapTime_q.put(lapTime)

    t = threading.Timer(lapTime/1000, lapTimeEvent)
    t.start()

# configure the serial connections (the parameters differs on the device you are connecting to)

lapTime_q = queue.Queue()

trackLength = 800

serialObject = serial.Serial()
serialObject.baudrate = 9600
serialObject.parity = serial.PARITY_NONE
serialObject.stopbits = serial.STOPBITS_ONE
serialObject.bytesize = serial.EIGHTBITS
serialObject.timeout = 0.01

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


lapTimeEvent()

while 1:

    qdata = list(get_all_from_queue(lapTime_q))
    if(len(qdata) > 0):
        lapTime = qdata[0]
        comParameter1 = (lapTime >> 8) & 0xff
        comParameter2 = lapTime & 0xff
        serialObject.write(bytearray([ord('\xBB'),ord('\xA7'), comParameter1]))
        serialObject.write(bytearray([ord('\xBB'),ord('\xA8'), comParameter2]))
        print(lapTime)

    data = serialObject.read(3)
    if(len(data)<3):
        #print('Nothing received')
        continue
    comType = hex(data[0])
    comCommand = hex(data[1])
    comParameter = data[2]

    #If it is a get type
    if(comType == '0xaa'):

        value = random.randint(0,0xffff)
        comParameter1 = (value >> 8) & 0xff
        comParameter2 = value & 0xff

        #Yaccel
        if(comCommand == '0xa1'):
            serialObject.write(bytearray([ord('\xBB'),ord('\xA1'), comParameter1]))
            serialObject.write(bytearray([ord('\xBB'),ord('\xA2'), comParameter2]))

        #Zgyro
        elif(comCommand == '0xa3'):
            serialObject.write(bytearray([ord('\xBB'),ord('\xA3'), comParameter1]))
            serialObject.write(bytearray([ord('\xBB'),ord('\xA4'), comParameter2]))

        #Ticks
        elif(comCommand == '0xa5'):
            serialObject.write(bytearray([ord('\xBB'),ord('\xA5'), comParameter1]))
            serialObject.write(bytearray([ord('\xBB'),ord('\xA6'), comParameter2]))


    #If it is a set type
    elif(comType == '0x55'):
        if(comCommand == '0x10'):
            print('Car started with %d%% speed!' %comParameter)
        elif(comCommand == '0x11'):
            print('Car stopped!')

    else:
        print('Unspecified type!')





