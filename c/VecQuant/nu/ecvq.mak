#
##
##  For SunOS/Linux/IRIX
CFLAGS  = -O3 -ansi
#CFLAGS  = -O3 -ansi -D__NO_MATH_INLINES -static -Wall
#CFLAGS  = -g -static -Wall
CC 	= gcc

##
##  For IRIX - gcc
##

##
##  For IRIX64
##
#CFLAGS  = -O2
#CC 	= cc

OBJS = ecvq.o vquant.o mfutils.o vecsort.o ../../Matlib/${OSNAME}/matlib.o

ecvq: ${OBJS}
	${CC} ${CFLAGS} ${OBJS} -lm -o ecvq

ecvq.o: ecvq.c
	${CC} ${CFLAGS} -c ecvq.c

vquant.o: vquant.c vquant.h vecsort.o
	${CC} ${CFLAGS} -c vquant.c

../../Matlib/${OSNAME}/matlib.o: ../../Matlib/matlib.c ../../Matlib/matlib.h
	cd ../../Matlib/${OSNAME}; $(MAKE) -f matlib.mak

mfutils.o: mfutils.c
	${CC} ${CFLAGS} -c mfutils.c

vecsort.o: vecsort.c
	${CC} ${CFLAGS} -c vecsort.c

clean:
	rm -f ${OBJS} ecvq
