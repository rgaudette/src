#
CFLAGS = -O3 -ansi
#CFLAGS = -O3 -ansi -D__NO_MATH_INLINES -static
#CFLAGS  = -g -static
CC 	= gcc

OBJS = vqtest.o vquant.o mfutils.o vecsort.o ../matlib/matlib.o

vqtest: ${OBJS}
	${CC} ${CFLAGS} ${OBJS} -lm -o vqtest

vqtest.o: vqtest.c
	${CC} ${CFLAGS} -c vqtest.c

vquant.o: vquant.c vquant.h vecsort.o
	${CC} ${CFLAGS} -c vquant.c

../matlib/matlib.o: ../matlib/matlib.c ../matlib/matlib.h
	cd ../matlib; $(MAKE) -f matlib.mak

mfutils.o: mfutils.c
	${CC} ${CFLAGS} -c mfutils.c

vecsort.o: vecsort.c
	${CC} ${CFLAGS} -c vecsort.c

clean:
	rm -f ${OBJS} vqtest
