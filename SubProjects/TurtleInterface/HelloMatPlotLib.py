import sys
import random
import math
import numpy as np
import matplotlib
matplotlib.use("Qt5Agg")
from PyQt5 import QtCore
from PyQt5.QtCore import Qt, QTimer
from PyQt5.QtWidgets import QApplication, QCheckBox, \
                            QMainWindow, QMenu, QHBoxLayout,\
                            QVBoxLayout,QPushButton, QSizePolicy, \
                            QMessageBox, QWidget, QLabel, QDialog, \
                            QComboBox, QSlider, QLCDNumber, QScrollArea, \
                            QLineEdit, QToolTip, QListWidget
from Dialogs import SerialConnectDialog

from PyQt5.QtGui import QPixmap, QIcon, QPalette, QColor
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
#from matplotlib.figure import Figure
import matplotlib.pyplot as plt
import serial
import queue
from com_monitor import ComMonitorThread
from data_puller import ComDataPullerThread
from globals import *

class ApplicationWindow(QMainWindow):
    def __init__(self):

        #Initialization stuff

        QMainWindow.__init__(self)
        self.setAttribute(QtCore.Qt.WA_DeleteOnClose)
        self.setWindowTitle("Turtle Window")            #Name of the specific window

        self.setStyleSheet("""
        QMainWindow {
            background-color:#437919;
        }

        QMenuBar {
            background-color:#313131;
            color: rgb(255,255,255);
            border: 1px solid #000;
        }

        QMenuBar::item {
            background-color: rgb(49,49,49);
            color: rgb(255,255,255);
        }

        QMenuBar::item::selected {
            background-color: rgb(30,30,30);
        }

        QMenu {
            background-color: rgb(49,49,49);
            color: rgb(255,255,255);
            border: 1px solid #000;
        }

        QMenu::item::selected {
            background-color: rgb(30,30,30);
        }

        QStatusBar {
            background-color:#313131;
            color: rgb(255,255,255);
            border: 1px solid #000;
        }

        """)

        #Serial Setup
        self.serialObject = serial.Serial()
        self.serialObject.baudrate = 9600
        self.serialObject.parity = serial.PARITY_NONE
        self.serialObject.stopbits = serial.STOPBITS_ONE
        self.serialObject.bytesize = serial.EIGHTBITS
        self.serialObject.timeout = None

        #Variables
        self.liveUpdate = False

        self.datapulls = 0

        self.dataSamples = []

        self.dataYaccelSamples = []
        self.dataZgyroSamples = []
        self.dataTickSamples = []

        self.lapTimes = []
        self.speeds = []

        #Data stuff
        self.com_monitor = None
        self.com_data_puller = None
        self.com_data_Yaccel_q = None
        self.com_data_Zgyro_q = None
        self.com_data_Tick_q = None
        self.com_data_Lap_q = None
        self.com_terminal_q = None

        self.liveFeed = LiveDataFeed()

        self.dataTimerUpdateRate = 25

        self.plotUpdater = QTimer(self)
        self.plotUpdater.timeout.connect(self.UpdateData)

        #Menues

        #File menu

        self.file_menu = QMenu('&File', self)
        self.file_menu.addAction('&Quit', self.fileQuit, QtCore.Qt.CTRL + QtCore.Qt.Key_Q)
        self.menuBar().addMenu(self.file_menu)

        #Help menu

        self.help_menu = QMenu('&Help', self)
        self.menuBar().addSeparator()
        self.menuBar().addMenu(self.help_menu)
        self.help_menu.addAction('&About', self.about)

        #Serial Menu

        self.serial_menu = QMenu('&Serial', self)
        self.menuBar().addSeparator()
        self.menuBar().addMenu(self.serial_menu)

        serialConnectAction = self.serial_menu.addAction('Connect')
        serialConnectAction.setShortcut(QtCore.Qt.Key_C)
        serialConnectAction.triggered.connect(self.serialConnect)
        serialConnectAction.setIcon(QIcon('SerialConnect.png'))

        serialReconnectAction = self.serial_menu.addAction('Reconnect')
        serialReconnectAction.setShortcut(QtCore.Qt.Key_R)
        serialReconnectAction.triggered.connect(self.serialReconnect)
        serialReconnectAction.setIcon(QIcon('SerialReconnect.png'))

        serialDisconnectAction = self.serial_menu.addAction('Disconnect')
        serialDisconnectAction.triggered.connect(self.serialDisconnect)
        serialDisconnectAction.setIcon(QIcon('SerialDisconnect.png'))

        #GUI


        #Stats
        self.labelLaptime = QLabel('Laptime', self)
        self.labelLaptime.setStyleSheet("background-color:#FFFFFF")
        self.labelLaptime.setAlignment(Qt.AlignLeft)

        self.labelSpeed = QLabel('Speed', self)
        self.labelSpeed.setStyleSheet("background-color:#FFFFFF")
        self.labelSpeed.setAlignment(Qt.AlignLeft)

        self.labelSpeedAvg = QLabel('Speed avg.', self)
        self.labelSpeedAvg.setStyleSheet("background-color:#FFFFFF")
        self.labelSpeedAvg.setAlignment(Qt.AlignLeft)


        #Start/Stop interface
        self.buttonStart = QPushButton('Start',self)
        self.buttonStart.setStyleSheet("background-color:#00FF00")
        self.buttonStart.clicked.connect(self.buttonStartPressed)

        buttonStop = QPushButton('Stop',self)
        buttonStop.setStyleSheet("background-color:#FF6666")
        buttonStop.clicked.connect(self.CarStop)

        self.lineEditSpeed = QLineEdit('35')
        self.lineEditSpeed.setStyleSheet("background-color:#FFFFFF")
        self.lineEditSpeed.returnPressed.connect(self.buttonStartPressed)
        self.lineEditSpeed.setSizePolicy(QSizePolicy.Minimum,QSizePolicy.Fixed)


        #Terminal
        terminalSize = 100

        self.labelTerminal = QLabel('>>Terminal Ready<br />',self)
        self.labelTerminal.setAlignment(Qt.AlignLeft | Qt.AlignTop)
        self.labelTerminal.setWordWrap(True)
        self.labelTerminal.setStyleSheet("background-color:#000000; color:#FFFFFF")
        self.labelTerminal.setTextFormat(Qt.RichText)

        self.scrollAreaTerminal = QScrollArea()
        self.scrollAreaTerminal.setWidget(self.labelTerminal)
        self.scrollAreaTerminal.setWidgetResizable(True)
        self.scrollAreaTerminal.verticalScrollBar().rangeChanged.connect(self.terminalScrollToBottom)

        self.lineEditTerminal = QLineEdit()
        self.lineEditTerminal.setStyleSheet("background-color:#FFFFFF")
        self.lineEditTerminal.returnPressed.connect(self.terminalLineEditEnter)
        self.lineEditTerminal.setToolTip('Use , to seperate bytes')

        self.comboboxTerminalType = QComboBox(self)
        self.comboboxTerminalType.addItem("HEX")
        self.comboboxTerminalType.addItem("DEC")

        #Plot list
        self.listPlots = QListWidget(self)
        self.listPlots.setMaximumWidth(200)

        #Layout

        self.main_widget = QWidget(self)

        turtlePicLabel = QLabel(self)
        turtlePic = QPixmap("Turtle.jpg")
        turtlePicLabel.setPixmap(turtlePic)

        hbox = QHBoxLayout()
        vbox = QVBoxLayout()
        vbox.setAlignment(Qt.AlignRight)
        vbox.addWidget(turtlePicLabel)
        vbox.addWidget(self.lineEditSpeed)
        vbox.addWidget(self.buttonStart)
        vbox.addWidget(buttonStop)
        vbox.addStretch(1)

        v2box = QVBoxLayout()

        self.figure = plt.figure()
        self.canvas = FigureCanvas(self.figure)
        self.canvas.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Expanding)
        self.canvas.updateGeometry()
        self.plot()

        statbox = QVBoxLayout()
        statbox.addWidget(self.listPlots)
        statbox.addWidget(self.labelLaptime)
        statbox.addWidget(self.labelSpeed)
        statbox.addWidget(self.labelSpeedAvg)

        hbox.addWidget(self.canvas)
        hbox.addLayout(statbox)
        hbox.addLayout(vbox)

        hbox2 = QHBoxLayout()
        hbox2.addWidget(self.lineEditTerminal)
        hbox2.addWidget(self.comboboxTerminalType)

        v2box.addLayout(hbox)
        v2box.addWidget(self.scrollAreaTerminal)
        v2box.addLayout(hbox2)

        self.main_widget.setLayout(v2box)

        self.main_widget.setFocus()
        self.setCentralWidget(self.main_widget)

        self.statusBar().showMessage("TURTLES, TURTLES, TURTLES!", 5000)

    def updateLaptime(self):
        self.labelLaptime.setText("Laptime: " +str(self.lapTimes[len(self.lapTimes)-1]))


    def read_serial_data(self):
        qdata = list(get_all_from_queue(self.com_data_Yaccel_q))
        if(len(qdata) > 0):
            print("Received Yaccel data")
            for dataSet in qdata:
                self.dataYaccelSamples.append(dataSet)

        qdata = list(get_all_from_queue(self.com_data_Zgyro_q))
        if(len(qdata) > 0):
            print("Received Zgyro data")
            for dataSet in qdata:
                self.dataZgyroSamples.append(dataSet)

        qdata = list(get_all_from_queue(self.com_data_Tick_q))
        if(len(qdata) > 0):
            print("Received ticks data")
            for dataSet in qdata:
                self.dataTickSamples.append(dataSet)

        qdata = list(get_all_from_queue(self.com_data_Lap_q))
        if(len(qdata) > 0):
            self.dataSamples.append((self.dataYaccelSamples))
            #print(len(self.dataYaccelSamples), self.labelLaptime.text(), self.datapulls)
            #self.dataYaccelSamples = []
            self.lapTimes.append(qdata[0])
            self.updateLaptime()

    def UpdateData(self):
        self.read_serial_data()
        self.plot()

        if(len(self.dataTickSamples)>= 2):
            sampleLast = self.dataTickSamples[len(self.dataTickSamples)-1]
            sampleSecondLast = self.dataTickSamples[len(self.dataTickSamples)-2]

            ticks = sampleLast[0] - sampleSecondLast[0]
            time = sampleLast[1] - sampleSecondLast[1]

            distance = ((ticks/12)*math.pi*2.5)/100
            speed = distance/time
            self.speeds.append(speed)
            self.labelSpeed.setText("Speed: " + "%.2f" %speed)

        if(len(self.speeds)>0):
            speedAvg = np.mean(self.speeds)
            self.labelSpeedAvg.setText("Speed: " + "%.2f" %speedAvg)


    def plot(self):

        ax = self.figure.add_subplot(111)
        ax.hold(False)
        x_list = [y for [x, y] in self.dataZgyroSamples]
        y_list = [x for [x, y] in self.dataZgyroSamples]

        ax.plot(x_list, y_list, 'r')
        ax.set_title('Graf')
        ax.set_ylabel('Y-Acceleration')
        ax.set_xlabel('Time')
        #ax.set_xlim([0, 5])
        #ax.set_ylim([0, 65535])
        #ax.autoscale(True)
        self.figure.tight_layout()
        self.canvas.draw()

    def terminalLineEditEnter(self):
        if self.serialObject.isOpen() == True:
            input_text = self.lineEditTerminal.text()

            input_type = 'None'

            input_bytes = input_text.split(',')

            if self.comboboxTerminalType.currentText() == "HEX":
                input_type = "HEX"
                for byte in range(0, len(input_bytes)):
                    input_bytes[byte] = int(input_bytes[byte], 16)

                print('It was hex')

            elif self.comboboxTerminalType.currentText() == "DEC":
                input_type = "DEC"
                for byte in range(0, len(input_bytes)):
                    input_bytes[byte] = int(input_bytes[byte])

                print('It was ascii')

            self.terminalAppend(">><font color=#FFFF00>" +
                                    input_type + "(" + input_text + ")" +
                                    "</font> <br />")

            command = bytearray(input_bytes)
            self.serialObject.write(command)
        else:
            self.terminalAppend(">><font color=#FF0000>" +
                                    "Serial port not open!"+
                                    "</font> <br />")
        self.lineEditTerminal.setText("")

    def terminalScrollToBottom(self,min,max):
        self.scrollAreaTerminal.verticalScrollBar().setValue(max)

    def terminalAppend(self, textToAppend):
        text = self.labelTerminal.text()
        text += textToAppend
        self.labelTerminal.setText(text)

    def buttonStartPressed(self):
        text = self.lineEditSpeed.text()
        self.lineEditSpeed.setText("")
        try:
            value = int(text)
        except ValueError:
            return

        if(value <= 100 and value >=0):
            self.CarStart(value)

    def CarStart(self, speed):
        if self.serialObject.isOpen():
            command = bytearray([ord('\x55'), ord('\x10'), speed])
            self.serialObject.write(command)
            self.terminalAppend(">><font color=#00FF00>" +
                                "Starting the car with " +
                                str(speed) +
                                "% speed!" +
                                "</font> <br />")

    def CarStop(self):
        if self.serialObject.isOpen():
            command = bytearray([ord('\x55'), ord('\x11'), 0])
            self.serialObject.write(command)
            self.terminalAppend(">><font color=#FF0000>" +
                                "Stopping the car!" +
                                "</font> <br />")

    def serialConnect(self):
        if self.serialObject.isOpen():
             self.statusBar().showMessage("Serial communication is already running on " + self.serialObject.port + "!", 3000)
        else:
            portSelected, ok = SerialConnectDialog.getPort(self)
            if(ok == True):
                try:
                    self.serialObject.port = portSelected
                    self.serialObject.open()
                    self.statusBar().showMessage("Opened serial communication on " + portSelected + "!", 3000)

                    self.startDaemons()

                except serial.SerialException :
                   self.statusBar().showMessage("Could not open serial connection on " + portSelected + "!", 3000)

            else:
                self.statusBar().showMessage("Serial connection cancelled!", 3000)

    def startDaemons(self):
        self.plotUpdater.start(self.dataTimerUpdateRate)

        self.com_data_Yaccel_q = queue.Queue()
        self.com_data_Zgyro_q = queue.Queue()
        self.com_data_Tick_q = queue.Queue()
        self.com_terminal_q = queue.Queue()
        self.com_data_Lap_q = queue.Queue()
        self.com_monitor = ComMonitorThread(self.com_data_Yaccel_q,
                                            self.com_data_Zgyro_q,
                                            self.com_data_Tick_q,
                                            self.com_data_Lap_q,
                                            self.com_terminal_q,
                                            self.serialObject)
        self.com_monitor.daemon = True
        self.com_monitor.start()
        self.com_data_puller = ComDataPullerThread(self.serialObject, 100)
        self.com_data_puller.start()

    def serialReconnect(self):
        if self.serialObject.isOpen():
             self.statusBar().showMessage("Serial communication is already running on " + self.serialObject.port + "!", 3000)
        else:
            try:
                self.serialObject.open()
                self.statusBar().showMessage("Opened serial communication on " + self.serialObject.port + "!", 3000)
                self.startDaemons()

            except serial.SerialException :
                self.statusBar().showMessage("Could not open serial connection on " + self.serialObject.port + "!", 3000)

    def serialDisconnect(self):
        if self.serialObject.isOpen():
            self.com_monitor.join()
            self.com_monitor = None
            self.serialObject.close()
            self.statusBar().showMessage("Closed serial communication on " + self.serialObject.port + "!", 3000)
        else:
            self.statusBar().showMessage("No serial port to be closed!", 3000)

    def fileQuit(self):
        self.close()

    def closeEvent(self, ce):
        self.fileQuit()

    def about(self):
        QMessageBox.about(self, "About",
        """This is the turtle interface used for monitoring and modifying the behaviour of the Turtle Car""")

if __name__ == '__main__':
    app = QApplication(sys.argv)

    aw = ApplicationWindow()
    aw.setWindowTitle("Turtle Interface")
    aw.show()
    aw.serialConnect()
    app.exec_()