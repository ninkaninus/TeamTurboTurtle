# Makefile for programming ATmega32 using assembler
PROJECT=bil_2sem
PROGRAMMER=-c usbasp -P usb # For the large blue AVR MKII
#PROGRAMMER=-c avrispmkII -P usb # For the large blue AVR MKII
#PROGRAMMER=-c avrisp -P /dev/ttyUSB0  # For the small green programmer

default:
	sudo avrdude -p m32 $(PROGRAMMER) -U flash:w:$(PROJECT).hex

fuse:
	sudo avrdude -p m32 $(PROGRAMMER) -U hfuse:w:0xd9:m -U 	lfuse:w:0xFF:m 

clean:
	rm -f $(PROJECT).obj $(PROJECT).hex $(PROJECT).cof $(PROJECT).eep.hex

erase:
	sudo avrdude -p m32 $(PROGRAMMER) -e


	
	
