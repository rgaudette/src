#
#  Uncomment the desired CFLAGS option if compiling alone or to overide
#  CFLAGS definition from parent MAKE.
#
CFLAGS = -O3 -ansi -Wall
#CFLAGS = -O3 -ansi -D__NO_MATH_INLINES -static -Wall
#CFLAGS = -g -ansi -Wall
CC = gcc

##
##  For IRIX64
##
#CFLAGS  = -O2
#CC 	= cc

matlib.o: matlib.c matlib.h
	${CC} ${CFLAGS} -c matlib.c

clean:
	rm -f matlib.o
