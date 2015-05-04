__author__ = 'StjerneIdioten'
from tkinter import *

root = Tk()
root.title("Turtle Interface")
root.iconbitmap('Turtle.ico')
logo = PhotoImage(file="./Turtle.gif")

explanation = "This is a very pretty turtle!"
w2 = Label(root,
           justify =LEFT,
           compound=TOP,
           padx = 10,
           bg = "green",
           text=explanation,image=logo).pack(side="right")

root.mainloop()