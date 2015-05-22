from PyQt5.QtWidgets import QHBoxLayout,QVBoxLayout,QPushButton,\
                            QLabel, QDialog, QComboBox

from PyQt5.QtGui import QIcon

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