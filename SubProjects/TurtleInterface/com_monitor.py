import queue
import threading
import time
from globals import *

import serial

class ComMonitorThread(threading.Thread):

    def __init__(   self, 
                    Yaccel_q,
                    Zgyro_q,
                    tick_q,
                    lap_q,
                    terminal_q,
                    serialObject):
        threading.Thread.__init__(self)
        
        self.serialObj = serialObject

        self.Yaccel_q = Yaccel_q
        self.Zgyro_q = Zgyro_q
        self.tick_q = tick_q
        self.lap_q = lap_q
        self.terminal_q = terminal_q

        self.alive = threading.Event()
        self.alive.set()
        
    def run(self):

        self.startTime = time.clock()
        
        while self.alive.isSet():

            dataFirst = self.serialObj.read(3)

            timeStamp = time.clock() - self.startTime


            if(hex(dataFirst[0])=='0xbb'):

                #Y-Acceleration
                if(hex(dataFirst[1])=='0xa1'):

                    dataSecond = self.serialObj.read(3)

                    if(hex(dataSecond[1])=='0xa2'):

                        data = (int(dataFirst[2])*256)+int(dataSecond[2])

                        data = self.ConvertToSigned(data)

                        self.Yaccel_q.put((data, timeStamp))

                #Z-Gyro
                elif(hex(dataFirst[1])=='0xa3'):

                    dataSecond = self.serialObj.read(3)

                    if(hex(dataSecond[1])=='0xa4'):

                        data = (int(dataFirst[2])*256) + int(dataSecond[2])

                        data = self.ConvertToSigned(data)

                        self.Zgyro_q.put((data, timeStamp))

                #Ticks
                elif(hex(dataFirst[1])=='0xa5'):

                    dataSecond = self.serialObj.read(3)

                    if(hex(dataSecond[1])=='0xa6'):

                        data = (int(dataFirst[2])*256)+int(dataSecond[2])

                        self.tick_q.put((data, timeStamp))

                elif(hex(dataFirst[1])=='0xa7'):

                    self.startTime = time.clock()

                    dataSecond = self.serialObj.read(3)

                    if(hex(dataSecond[1])=='0xa8'):

                        laptime = ((int(dataFirst[2])*256)+int(dataSecond[2]))/1000

                        dataThird = self.serialObj.read(3)

                        if(hex(dataThird[1])=='0xa9'):

                            dataFourth = self.serialObj.read(3)

                            if(hex(dataFourth[1])=='0xaa'):

                                lapTicks = (int(dataThird[2])*256)+int(dataFourth[2])

                                self.lap_q.put((laptime, lapTicks ))
                else:
                    print('Non comm command')
            else:
                print('Non comm type')

    def ConvertToSigned(self,number):
        if (number > 32767):
            return number - 65536
        else:
            return number


    def join(self, timeout=None):
        print("Ending")
        self.alive.clear()
        threading.Thread.join(self, timeout)
