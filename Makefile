OBJS += main.o qthread.o ctx.o
NASM ?= /usr/local/bin/nasm
TARGET ?= hbs
CC = gcc
CFLAGS += -g
LINKOPTS += -Wl,-no_pie
all: $(TARGET)

.SUFFIXES: .c .o
.SUFFIXES: .asm .o

$(TARGET) : $(OBJS)
	$(CC) $(OBJS) -o $(TARGET) $(CFLAGS) $(LINKOPTS)

.asm.o: $<
	$(NASM) -f macho64 $<

.c.o :	$<
	$(CC) -c $< $(CFLAGS)

clean:
	rm -rf $(OBJS) $(TARGET) *~
