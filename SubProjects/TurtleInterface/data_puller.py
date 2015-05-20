import threading
import serial
import time

class ComDataPullerThread():

    def __init__(   self, serialObject, updateFreq):
        self.serialObj = serialObject
        self.updateFreq = updateFreq
        self.active = True
        self.delay = 0.1

    def pullData(self):

        #Pull Yaccel
        command = bytearray([ord('\xAA'), ord('\xa1'), 0])
        self.serialObj.write((command))

        #time.sleep(self.delay)

        #Pull Zgyro
        command = bytearray([ord('\xAA'), ord('\xa3'), 0])
        self.serialObj.write((command))

        #time.sleep(self.delay)

        '''
        #Pull Ticks
        command = bytearray([ord('\xAA'), ord('\xa5'), 0])
        self.serialObj.write((command))
        '''

        #time.sleep(self.delay)

        if(self.active == True):
            t = threading.Timer(1/self.updateFreq, self.pullData)
            t.start()
        else:
            print('Puller inactive')

    def start(self):
        self.active = True
        t = threading.Timer(1/self.updateFreq, self.pullData)
        t.daemon = True
        t.start()

    def stop(self):
        self.active = False
