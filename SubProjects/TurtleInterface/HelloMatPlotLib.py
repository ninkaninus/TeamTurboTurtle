import sys
import random
import matplotlib
matplotlib.use("Qt5Agg")
from PyQt5 import QtCore
from PyQt5.QtCore import Qt
from PyQt5.QtWidgets import QApplication,QAction, QCheckBox, \
                            QMainWindow, QMenu, QHBoxLayout,\
                            QVBoxLayout,QPushButton, QSizePolicy, \
                            QMessageBox, QWidget, QLabel, QDialog, \
                            QComboBox, QSlider, QLCDNumber, QScrollArea
from PyQt5.QtGui import QPixmap, QIcon, QPalette, QColor
from numpy import arange, sin, pi
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.figure import Figure
import serial
import glob

class MyMplCanvas(FigureCanvas):
    """Ultimately, this is a QWidget (as well as a FigureCanvasAgg, etc.)."""
    def __init__(self, parent=None, width=5, height=4, dpi=100):
        fig = Figure(figsize=(width, height), dpi=dpi)
        self.axes = fig.add_subplot(111)
        # We want the axes cleared every time plot() is called
        self.axes.hold(False)

        self.compute_initial_figure()

        #
        FigureCanvas.__init__(self, fig)
        self.setParent(parent)

        FigureCanvas.setSizePolicy(self, QSizePolicy.Expanding, QSizePolicy.Expanding)

        FigureCanvas.updateGeometry(self)

    def compute_initial_figure(self):
        pass


class MyStaticMplCanvas(MyMplCanvas):
    """Simple canvas with a sine plot."""
    def compute_initial_figure(self):
        t = arange(0.0, 3.0, 0.01)
        s = sin(2*pi*t)
        self.axes.plot(t, s)


class MyDynamicMplCanvas(MyMplCanvas):
    """A canvas that updates itself every second with a new plot."""
    def __init__(self, *args, **kwargs):
        MyMplCanvas.__init__(self, *args, **kwargs)
        timer = QtCore.QTimer(self)
        timer.timeout.connect(self.update_figure)
        timer.start(1000)

    def compute_initial_figure(self):
        self.axes.plot([0, 1, 2, 3], [1, 2, 0, 4], 'r')

    def update_figure(self):
        # Build a list of 4 random integers between 0 and 10 (both inclusive)

        if random.randint(0,1) == 1:

            l = [random.randint(10, 20) for i in range(7)]
            self.axes.plot([0, 1, 2, 3,4,5,6], l, 'r')
            self.draw()
        else:
            l = [random.randint(0, 10) for i in range(4)]
            self.axes.plot([0, 1, 2, 3], l, 'r')
            self.draw()

class SerialConnectDialog(QDialog):
    def __init__(self, parent=None):
        QDialog.__init__(self)

        self.setWindowTitle('Serial Connection')
        self.setWindowIcon(QIcon('SerialConnect.png'))

        #Variables for returning

        vbox = QVBoxLayout()

        #Port box

        portBox = QHBoxLayout()
        portLabel = QLabel('Port',self)
        portBox.addWidget(portLabel)


        self.portCombo = QComboBox(self)

        for i in range(1,31):
            self.portCombo.addItem("COM%d" %i)

        portBox.addWidget(self.portCombo)
        portBox.addStretch(1)

        vbox.addLayout(portBox)

        vbox.addStretch(1)

        buttonConnect = QPushButton('Connect', self)
        buttonConnect.clicked.connect(self.accept)
        vbox.addWidget(buttonConnect)

        self.setLayout(vbox)

    def returnPort(self):
        return self.portCombo.currentText()

    @staticmethod
    def getPort(parent = None):
        dialog = SerialConnectDialog(parent)
        result = dialog.exec_()
        portSelected = dialog.returnPort()
        return (portSelected, result == QDialog.Accepted)

    def serial_ports(self):
        if sys.platform.startswith('win'):
            ports = ['COM' + str(i + 1) for i in range(20)]

        elif sys.platform.startswith('linux') or sys.platform.startswith('cygwin'):
            # this is to exclude your current terminal "/dev/tty"
            ports = glob.glob('/dev/tty[A-Za-z]*')

        elif sys.platform.startswith('darwin'):
            ports = glob.glob('/dev/tty.*')
        else:
            raise EnvironmentError('Unsupported platform')

        result = []

        for port in ports:
            try:
                s = serial.Serial(port)
                s.close()
                result.append(port)
            except (OSError, serial.SerialException):
                pass
        return result

class ApplicationWindow(QMainWindow):
    def __init__(self):

        #Serial Setup
        self.serialObject = serial.Serial()
        self.serialObject.baudrate = 9600
        self.serialObject.parity = serial.PARITY_NONE
        self.serialObject.stopbits = serial.STOPBITS_ONE
        self.serialObject.bytesize = serial.EIGHTBITS

        #Variables
        self.liveUpdate = False

        #Initialization stuff

        QMainWindow.__init__(self)
        self.setAttribute(QtCore.Qt.WA_DeleteOnClose)
        self.setWindowTitle("Turtle Window")            #Name of the specific window

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

        #Sliders

        self.sliderSpeed = QSlider(Qt.Horizontal, self)
        self.sliderSpeed.setMaximum(100)
        self.sliderSpeed.setStyleSheet("background-color:#FFFFFF")
        self.sliderSpeed.setFocusPolicy(Qt.NoFocus)
        self.sliderSpeed.valueChanged[int].connect(self.sliderSpeedAdjust)

        #Terminal
        terminalSize = 100

        self.labelTerminal = QLabel('>>Terminal Ready\n',self)
        self.labelTerminal.setAlignment(Qt.AlignLeft | Qt.AlignTop)
        self.labelTerminal.setWordWrap(True)
        self.labelTerminal.setStyleSheet("background-color:#000000; color:#FFFFFF")

        scrollAreaTerminal = QScrollArea()
        scrollAreaTerminal.setWidget(self.labelTerminal)
        scrollAreaTerminal.setWidgetResizable(True)
        scrollAreaTerminal.setFixedHeight(terminalSize)

        #Layout

        self.main_widget = QWidget(self)

        turtlePicLabel = QLabel(self)
        turtlePic = QPixmap("Turtle.jpg")
        turtlePicLabel.setPixmap(turtlePic)

        hbox = QHBoxLayout()
        vbox = QVBoxLayout()
        vbox.addWidget(turtlePicLabel)
        vbox.addWidget(self.lcdSpeed)
        vbox.addWidget(self.sliderSpeed)
        vbox.addWidget(self.buttonStart)
        vbox.addWidget(buttonStop)
        vbox.addStretch(1)

        v2box = QVBoxLayout()

        dc = MyDynamicMplCanvas(self.main_widget, width=5, height=4, dpi=100)

        hbox.addWidget(dc)
        hbox.addLayout(vbox)

        v2box.addLayout(hbox)
        v2box.addWidget(scrollAreaTerminal)
        v2box.addStretch(1)

        self.main_widget.setLayout(v2box)

        self.main_widget.setFocus()
        self.setCentralWidget(self.main_widget)

        self.statusBar().showMessage("TURTLES, TURTLES, TURTLES!", 5000)

    def buttonStartToggle(self):
        self.liveUpdate = not self.liveUpdate
        if self.liveUpdate == True:
            self.buttonStart.setText('Live!')
            self.buttonStart.setStyleSheet("background-color:#FFFF00")
            self.sliderSpeed.setStyleSheet("background-color:#99FF33")
            self.CarStart(self.sliderSpeed.value())
        else:
            self.buttonStart.setStyleSheet("background-color:#00FF00")
            self.sliderSpeed.setStyleSheet("background-color:#FFFFFF")
            self.buttonStart.setText('Start')

    def sliderSpeedAdjust(self, value):
        self.lcdSpeed.display(value)
        if self.liveUpdate == True:
            self.CarStart(value)

    def CarStart(self, speed):
        if self.serialObject.isOpen():
            self.statusBar().showMessage("Starting the car!", 3000)
            command = bytearray([ord('\x55'), ord('\x10'), speed])
            self.serialObject.write(command)

    def CarStop(self):
        if self.serialObject.isOpen():
            self.statusBar().showMessage("Stopping the car!", 3000)
            command = bytearray([ord('\x55'), ord('\x10'), 0])
            self.serialObject.write(command)

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
    app.exec_()