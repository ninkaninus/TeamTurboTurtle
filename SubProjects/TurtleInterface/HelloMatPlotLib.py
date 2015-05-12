import sys
import random
import matplotlib
matplotlib.use("Qt5Agg")
from PyQt5 import QtCore
from PyQt5.QtCore import Qt
from PyQt5.QtWidgets import QApplication,QAction, QCheckBox, \
                            QMainWindow, QMenu, QHBoxLayout,\
                            QVBoxLayout,QPushButton, QSizePolicy, \
                            QMessageBox, QWidget, QLabel, QDialog, QComboBox
from PyQt5.QtGui import QPixmap, QIcon
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

        serialDisconnectAction = self.serial_menu.addAction('Disconnect')
        serialDisconnectAction.triggered.connect(self.serialDisconnect)
        serialDisconnectAction.setIcon(QIcon('SerialDisconnect.png'))

        #GUI

        cb = QCheckBox('Penis', self)

        Qb1 = QPushButton('Button1',self)
        Qb1.setCheckable(True)
        Qb2 = QPushButton('Button2',self)
        Qb3 = QPushButton('Button3',self)
        Qb4 = QPushButton('Button4',self)

        self.main_widget = QWidget(self)

        turtlePicLabel = QLabel(self)
        turtlePic = QPixmap("Turtle.jpg")
        turtlePicLabel.setPixmap(turtlePic)

        hbox = QHBoxLayout()
        vbox = QVBoxLayout()
        vbox.addWidget(turtlePicLabel)
        vbox.addStretch(1)
        vbox.addWidget(cb)
        vbox.addWidget(Qb1)
        vbox.addWidget(Qb2)
        vbox.addWidget(Qb3)
        vbox.addWidget(Qb4)

        dc = MyDynamicMplCanvas(self.main_widget, width=5, height=4, dpi=100)

        hbox.addWidget(dc)
        hbox.addLayout(vbox)

        self.main_widget.setLayout(hbox)

        self.main_widget.setFocus()
        self.setCentralWidget(self.main_widget)

        self.statusBar().showMessage("TURTLES, TURTLES, TURTLES!", 5000)

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