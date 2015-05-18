import queue
import threading
import time
from globals import *

import serial

class ComMonitorThread(threading.Thread):
    """ A thread for monitoring a COM port. The COM port is 
        opened when the thread is started.
    
        data_q:
            Queue for received data. Items in the queue are
            (data, timestamp) pairs, where data is a binary 
            string representing the received data, and timestamp
            is the time elapsed from the thread's start (in 
            seconds).
        
        terminal_q:

        serialObject:


        

    """
    def __init__(   self, 
                    Yaccel_q,
                    Zgyro_q,
                    tick_q,
                    terminal_q,
                    serialObject):
        threading.Thread.__init__(self)
        
        self.serialObj = serialObject

        self.startTime = time.clock()

        self.Yaccel_q = Yaccel_q
        self.Zgyro_q = Zgyro_q
        self.tick_q = tick_q
        self.terminal_q = terminal_q
        
        self.alive = threading.Event()
        self.alive.set()
        
    def run(self):
        
        # Restart the clock
        time.clock()
        
        while self.alive.isSet():

            dataFirst = self.serialObj.read(3)

            timeStamp = time.clock() - self.startTime

            if(hex(dataFirst[0])=='0xbb'):

                #Y-Acceleration
                if(hex(dataFirst[1])=='0xa1'):

                    dataSecond = self.serialObj.read(3)

                    if(hex(dataSecond[1])=='0xa2'):

                        data = (int(dataFirst[2])*256)+int(dataSecond[2])

                        self.Yaccel_q.put((data, timeStamp))

                        print(data, timeStamp)

                #Z-Gyro
                elif(hex(dataFirst[1])=='0xa3'):

                    dataSecond = self.serialObj.read(3)

                    if(hex(dataSecond[1])=='0xa4'):

                        data = (int(dataFirst[2])*256)+int(dataSecond[2])

                        self.Zgyro_q.put((data, timeStamp))

                        print(data, timeStamp)

            else:
                print('Non comm command')


    def join(self, timeout=None):
        self.alive.clear()
        threading.Thread.join(self, timeout)
