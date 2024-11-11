#
CFLAGS = -O3 -ansi -m486 -static -funroll-loops -Wall
#CFLAGS  = -g -ansi -static -Wall -m486
CC 	= gcc

OBJS = ecvq.o vquant.o mfutils.o vecsort.o ../Matlib/matlib.o

ecvq: ${OBJS}
	${CC} ${CFLAGS} ${OBJS} -lm -o ecvq

ecvq.o: ecvq.c
	${CC} ${CFLAGS} -c ecvq.c

vquant.o: vquant.c vquant.h vecsort.o
	${CC} ${CFLAGS} -c vquant.c

../Matlib/Matlib.o: ../Matlib/matlib.c ../Matlib/matlib.h
	cd ../Matlib; $(MAKE) -f matlib.mak

mfutils.o: mfutils.c
	${CC} ${CFLAGS} -c mfutils.c

vecsort.o: vecsort.c
	${CC} ${CFLAGS} -c vecsort.c

clean:
	rm -f ${OBJS} ecvq
