#
#  Uncomment the desired CFLAGS option if compiling alone or to overide
#  CFLAGS definition from parent MAKE.
#
CFLAGS = -O3 -ansi -m486 -static -funroll-loops -ffast-math
## -fomit-frame-pointer -finline-functions

#CFLAGS = -O3 -ansi -m486 -D__NO_MATH_INLINES -static
#CFLAGS = -g -ansi

##
##  For IRIX - gcc (note, this is slower than the native compiler)
##

#CFLAGS = -O2 -ansi -D__NO_MATH_INLINES -static

CC = gcc

##  For IRIX (native CC)/IRIX64
##
#CFLAGS  = -O2
#CC 	= cc

OBJS = matmult2.o ../matlib/matlib.o

matmult2: ${OBJS}
	${CC} ${CFLAGS} ${OBJS} -o matmult2.exe

matmult2.o: matmult2.c
	${CC} ${CFLAGS} -c matmult2.c

../matlib/matlib.o: ../matlib/matlib.c ../matlib/matlib.h
	cd ../matlib; $(MAKE) -f matlib.mak

clean:
	rm -f *.o matmult2
