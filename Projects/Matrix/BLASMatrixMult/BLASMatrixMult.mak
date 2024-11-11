#
#  BLASBatrixMult makefile
#
CFLAGS=-O2 -I/usr/local/intel/mkl/INCLUDE
#LDFLAGS=-L/usr/local/intel/mkl/LIB -l
LDFLAGS=-lpthread
BLASMatrixMult: BLASMatrixMult.o ../Matrix.o libmkl32_def.a

#	ld BLASMatrixMult.o ../Matrix.o -o BLASMatrixMult ${LDFLAGS} -lm -lc

BLASMatrixMult.o: BLASMatrixMult.c

../Matrix.o: ../Matrix.c

.PHONY: clean

clean::
	rm -f BLASMatrixMult.o ../Matrix.o
