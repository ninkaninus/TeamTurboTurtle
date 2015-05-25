import threading
import serial
import time

class ComDataPullerThread():

    def __init__(   self, serialObject, updateFreq):
        self.serialObj = serialObject
        self.updateFreq = updateFreq
        self.active = True

    def pullData(self):

        if(self.active == True):

            #Pull data
            command = bytearray([ord('\xAA'), ord('\xab'), 0])
            self.serialObj.write((command))

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
