DEVICE      = attiny85
CLOCK       = 1000000
PROGRAMMER  = -c arduino 
OBJECTS     = Button.o buttontest.o
FUSES       = -U lfuse:w:0x62:m -U hfuse:w:0xdf:m -U efuse:w:0xff:m 
PORT	    = -P /dev/ttyACM0 -b19200
AVRDUDE     = avrdude -v $(PORT) $(PROGRAMMER) -p $(DEVICE)

CC	= avr-gcc
CPP	= avr-g++
CFLAGS	= -Wall -Os -DF_CPU=$(CLOCK) -mmcu=$(DEVICE)

all:	buttontest.hex

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.cpp
	$(CPP) $(CFLAGS) -c $< -o $@

%.o: %.S
	$(CC) $(CFLAGS) -x assembler-with-cpp -c $< -o $@

%.s: %.c
	$(CC) $(CFLAGS) -S $< -o $@

flash:	all
	$(AVRDUDE) -U flash:w:buttontest.hex:i

fuse:
	$(AVRDUDE) $(FUSES)

make: flash fuse

load: all
	bootloadHID buttontest.hex

clean:
	rm -f buttontest.hex buttontest.elf $(OBJECTS)

buttontest.elf: $(OBJECTS)
	$(CC) $(CFLAGS) -o buttontest.elf $(OBJECTS)

buttontest.hex: buttontest.elf
	rm -f buttontest.hex
	avr-objcopy -j .text -j .data -O ihex buttontest.elf buttontest.hex
	avr-size --format=avr --mcu=$(DEVICE) buttontest.elf
