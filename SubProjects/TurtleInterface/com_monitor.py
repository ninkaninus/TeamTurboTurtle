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
        
        error_q:
            Queue for error messages. In particular, if the 
            serial port fails to open for some reason, an error
            is placed into this queue.
        
        port:
            The COM port to open. Must be recognized by the 
            system.
        
        port_baud/stopbits/parity: 
            Serial communication parameters
        
        port_timeout:
            The timeout used for reading the COM port. If this
            value is low, the thread will return data in finer
            grained chunks, with more accurate timestamps, but
            it will also consume more CPU.
    """
    def __init__(   self, 
                    data_q,
                    serialObject):
        threading.Thread.__init__(self)
        
        self.serialObj = serialObject

        self.startTime = time.clock()

        self.data_q = data_q
        
        self.alive = threading.Event()
        self.alive.set()
        
    def run(self):
        
        # Restart the clock
        time.clock()
        
        while self.alive.isSet():

            data = self.serialObj.read(3)

            timeStamp = time.clock() - self.startTime

            self.data_q.put((int(data[2]), timeStamp))

            print(int(data[2]), timeStamp)

            '''
            if len(data) > 0:
                timestamp = time.clock()
                self.data_q.put((data, timestamp))
            '''

    def join(self, timeout=None):
        self.alive.clear()
        threading.Thread.join(self, timeout)
