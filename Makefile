CC = gcc
CFLAGS = -g -Wall -Werror -fsanitize=address

.PHONY: all clean

all: mysh

mysh: mysh.o builtins.o commands.o variables.o io_helpers.o 
	$(CC) $(CFLAGS) -o $@ $^

%.o: %.c builtins.h commands.h variables.h io_helpers.h 
	$(CC) $(CFLAGS) -c $<

clean:
	rm -f *.o mysh
