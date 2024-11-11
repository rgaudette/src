#
#CFLAGS = -O3 -ansi
CFLAGS = -O3 -ansi -D__NO_MATH_INLINES -static 
#CFLAGS  = -g -static
CC 	= gcc

OBJS = lbg.o vquant.o mfutils.o vecsort.o ../Matlib/matlib.o

lbg: ${OBJS}
	${CC} ${CFLAGS} ${OBJS} -lm -lgcc -o lbg

lbg.o: lbg.c
	${CC} ${CFLAGS} -c lbg.c

vquant.o: vquant.c vquant.h vecsort.o
	${CC} ${CFLAGS} -c vquant.c

../Matlib/Matlib.o: ../Matlib/matlib.c ../Matlib/matlib.h
	cd ../Matlib; $(MAKE) -f matlib.mak

mfutils.o: mfutils.c
	${CC} ${CFLAGS} -c mfutils.c

vecsort.o: vecsort.c
	${CC} ${CFLAGS} -c vecsort.c

clean:
	rm -f ${OBJS} lbg
