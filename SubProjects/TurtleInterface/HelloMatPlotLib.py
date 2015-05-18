import sys
import random
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
        self.serialObject.port_timeout=0.01

        #Variables
        self.liveUpdate = False
        self.dataYaccelSamples = []
        self.timeYaccelSamples = []

        self.dataZgyroSamples = []
        self.timeZgyroSamples = []

        #Data stuff
        self.com_monitor = None
        self.com_data_Yaccel_q = None
        self.com_data_Zgyro_q = None
        self.com_data_Tick_q = None
        self.com_terminal_q = None

        self.liveFeed = LiveDataFeed()

        self.dataTimerUpdateRate = 1

        self.dataTimerPullRate = 10

        self.plotUpdater = QTimer(self)
        self.plotUpdater.timeout.connect(self.plotUpdate)

        self.dataPuller = QTimer(self)
        self.dataPuller.timeout.connect(self.pullData)

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
        serialConnectAction.triggered.connect(self.serialConnect)
        serialConnectAction.setIcon(QIcon('SerialConnect.png'))

        serialReconnectAction = self.serial_menu.addAction('Reconnect')
        serialReconnectAction.triggered.connect(self.serialReconnect)
        serialReconnectAction.setIcon(QIcon('SerialReconnect.png'))

        serialDisconnectAction = self.serial_menu.addAction('Disconnect')
        serialDisconnectAction.triggered.connect(self.serialDisconnect)
        serialDisconnectAction.setIcon(QIcon('SerialDisconnect.png'))
        #GUI


        #Buttons

        self.buttonStart = QPushButton('Start',self)
        self.buttonStart.setCheckable(True)
        self.buttonStart.setStyleSheet("background-color:#00FF00")
        self.buttonStart.clicked[bool].connect(self.buttonStartToggle)

        buttonStop = QPushButton('Stop',self)
        buttonStop.setStyleSheet("background-color:#FF6666")
        buttonStop.clicked.connect(self.CarStop)

        #LCD
        self.lcdSpeed = QLCDNumber(self)
        self.lcdSpeed.setSegmentStyle(QLCDNumber.Flat)
        self.lcdSpeed.setStyleSheet("background-color:#FFFFFF")

        #Sliders

        self.sliderSpeed = QSlider(Qt.Horizontal, self)
        self.sliderSpeed.setMaximum(100)
        self.sliderSpeed.setStyleSheet("background-color:#FFFFFF")
        self.sliderSpeed.setFocusPolicy(Qt.NoFocus)
        self.sliderSpeed.valueChanged[int].connect(self.sliderSpeedAdjust)
        self.sliderSpeed.setSizePolicy(QSizePolicy.Minimum,QSizePolicy.Fixed)

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
        vbox.addWidget(self.lcdSpeed)
        vbox.addWidget(self.sliderSpeed)
        vbox.addWidget(self.buttonStart)
        vbox.addWidget(buttonStop)
        vbox.addStretch(1)

        v2box = QVBoxLayout()

        self.figure = plt.figure()
        self.canvas = FigureCanvas(self.figure)
        self.canvas.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Expanding)
        self.canvas.updateGeometry()
        self.plot()

        hbox.addWidget(self.canvas)
        hbox.addWidget(self.listPlots)
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

    def read_serial_data(self):
        qdata = list(get_all_from_queue(self.com_data_Yaccel_q))
        if(len(qdata) > 0):
            print("Received Yaccel data")
            for dataSet in qdata:
                self.dataYaccelSamples.append(dataSet[0])
                self.timeYaccelSamples.append(dataSet[1])

        qdata = list(get_all_from_queue(self.com_data_Zgyro_q))
        if(len(qdata) > 0):
            print("Received Zgyro data")
            for dataSet in qdata:
                self.dataZgyroSamples.append(dataSet[0])
                self.timeZgyroSamples.append(dataSet[1])

    def plotUpdate(self):
        self.read_serial_data()
        self.plot()

    def plot(self):

        ax = self.figure.add_subplot(111)
        ax.hold(False)
        ax.plot(self.timeYaccelSamples,self.dataYaccelSamples, 'r')
        ax.set_title('Graf')
        ax.set_ylabel('Y-Acceleration')
        ax.set_xlabel('Time')
        ax.autoscale(True)
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

    def pullData(self):

        #Pull Yaccel
        command = bytearray([ord('\xAA'), ord('\xa1'), 0])
        self.serialObject.write((command))

        #Pull Zgyro
        command = bytearray([ord('\xAA'), ord('\xa3'), 0])
        self.serialObject.write((command))

    def terminalScrollToBottom(self,min,max):
        self.scrollAreaTerminal.verticalScrollBar().setValue(max)

    def terminalAppend(self, textToAppend):
        text = self.labelTerminal.text()
        text += textToAppend
        self.labelTerminal.setText(text)

    def buttonStartToggle(self):
        if self.buttonStart.isChecked() == True:
            self.buttonStart.setText('Live!')
            self.buttonStart.setStyleSheet("background-color:#FFFF00")
            self.sliderSpeed.setStyleSheet("background-color:#99FF33")
            self.CarStart(self.sliderSpeed.value())

        else:
            self.buttonStartOff()

    def buttonStartOff(self):
        self.buttonStart.setStyleSheet("background-color:#00FF00")
        self.sliderSpeed.setStyleSheet("background-color:#FFFFFF")
        self.buttonStart.setText('Start')

    def sliderSpeedAdjust(self, value):
        self.lcdSpeed.display(value)
        if self.buttonStart.isChecked() == True:
            self.CarStart(value)


    def CarStart(self, speed):
        if self.serialObject.isOpen():
            self.statusBar().showMessage("Starting the car!", 3000)
            command = bytearray([ord('\x55'), ord('\x10'), speed])
            self.serialObject.write(command)
            self.terminalAppend(">><font color=#00FF00>" +
                                "Starting the car with " +
                                str(speed) +
                                "% speed!" +
                                "</font> <br />")

    def CarStop(self):
        self.buttonStart.setChecked(False)
        self.buttonStartOff()
        if self.serialObject.isOpen():
            self.statusBar().showMessage("Stopping the car!", 3000)
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

                    self.plotUpdater.start(self.dataTimerUpdateRate)
                    self.dataPuller.start(self.dataTimerPullRate)

                    self.com_data_Yaccel_q = queue.Queue()
                    self.com_data_Zgyro_q = queue.Queue()
                    self.com_data_Tick_q = queue.Queue()
                    self.com_terminal_q = queue.Queue()
                    self.com_monitor = ComMonitorThread(self.com_data_Yaccel_q,
                                                        self.com_data_Zgyro_q,
                                                        self.com_data_Tick_q,
                                                        self.com_terminal_q,
                                                        self.serialObject)
                    self.com_monitor.start()


                except serial.SerialException :
                   self.statusBar().showMessage("Could not open serial connection on " + portSelected + "!", 3000)

            else:
                self.statusBar().showMessage("Serial connection cancelled!", 3000)

    def serialReconnect(self):
        if self.serialObject.isOpen():
             self.statusBar().showMessage("Serial communication is already running on " + self.serialObject.port + "!", 3000)
        else:
            try:
                self.serialObject.open()
                self.statusBar().showMessage("Opened serial communication on " + self.serialObject.port + "!", 3000)
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