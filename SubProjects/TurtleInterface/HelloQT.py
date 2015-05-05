__author__ = 'StjerneIdioten'
import sys
from PyQt5.QtWidgets import (QWidget, QToolTip,
    QPushButton, QApplication)
from PyQt5.QtGui import QFont
from PyQt5.QtGui import QIcon
from PyQt5.QtCore import QCoreApplication

class Example(QWidget):

    def __init__(self):
        super().__init__()

        self.initUI()


    def initUI(self):

        QToolTip.setFont(QFont('SansSerif', 10))

        self.setToolTip('This is a <b>QWidget</b> widget')

        but1 = QPushButton('Button1',self)
        but1.setToolTip('This is a <b>QPushButton</b> widget')
        but1.resize(but1.sizeHint())
        but1.move(50,50)

        but2 = QPushButton('Button2',self)
        but2.setToolTip('This is another <b>QPushButton</b> widget')
        but2.resize(but1.sizeHint())
        but2.move(200,50)

        self.setGeometry(300, 300, 300, 220)
        self.setWindowTitle('Tooltips')
        self.setWindowIcon(QIcon('turtle.jpg'))
        self.show()


if __name__ == '__main__':

    app = QApplication(sys.argv)
    ex = Example()
    ex1 = Example()
    sys.exit(app.exec_())

