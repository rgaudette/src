#
#C_OPTS 	= -O3
C_OPTS  = -O3 -D__NO_MATH_INLINES -static
CC 	= gcc

matmult2: matmult2.c matlib.o
	${CC} ${C_OPTS} matmult2.c matlib.o -o matmult2

matlib.o: matlib.c matlib.h
	${CC} ${C_OPTS} -c matlib.c

clean:
	rm *.o matmult2
