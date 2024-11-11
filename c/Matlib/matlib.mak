#
#  Uncomment the desired CFLAGS option if compiling alone or to overide
#  CFLAGS definition from parent MAKE.
#
CFLAGS = -O3 -ansi -m486 -static -funroll-loops -ffast-math
##-fomit-frame-pointer -finline-functions

#CFLAGS = -O3 -ansi -m486 -D__NO_MATH_INLINES -static
#CFLAGS = -g -ansi

CC = gcc

matlib.o: matlib.c matlib.h
	${CC} ${CFLAGS} -c matlib.c

clean:
	rm -f matlib.o
