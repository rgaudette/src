#
#C_OPTS 	= -O3 -ansi
C_OPTS  = -g -ansi
CC 	= gcc

mfutest: mfutest.c mfutils.o matlib.o
	${CC} ${C_OPTS} mfutest.c mfutils.o matlib.o -o mfutest

mfutils.o: mfutils.c matlib.o
	${CC} ${C_OPTS} -c mfutils.c

matlib.o: matlib.c matlib.h
	${CC} ${C_OPTS} -c matlib.c

#clean:
#        rm *o mfutest
