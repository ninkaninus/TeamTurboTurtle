import threading
import serial

class ComDataPullerThread():

    def __init__(   self, serialObject, updateFreq):
        self.serialObj = serialObject
        self.updateFreq = updateFreq
        self.active = None
        self.pulls = 0

    def pullData(self):

        #Pull Yaccel
        command = bytearray([ord('\xAA'), ord('\xa1'), 0])
        self.serialObj.write((command))

        #Pull Zgyro
        command = bytearray([ord('\xAA'), ord('\xa3'), 0])
        self.serialObj.write((command))

        #Pull Ticks
        command = bytearray([ord('\xAA'), ord('\xa5'), 0])
        self.serialObj.write((command))

        if(self.active == True):
            print(self.pulls)
            self.pulls += 1
            t = threading.Timer(1/self.updateFreq, self.pullData)
            t.start()
        else:
            print('Puller inactive')

    def start(self):
        self.active = True
        t = threading.Timer(1/self.updateFreq, self.pullData)
        t.start()

    def stop(self):
        self.active = False
