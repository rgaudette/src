#
#  BLASBatrixMult makefile
#

#
#  Intel compiler and MKL
#
INTEL_MKL=/usr/local/intel/mkl
CFLAGS=-O2 -I${INTEL_MKL}/include
LDFLAGS=-L${INTEL_MKL}/lib/32 -lmkl_p3 -lpthread -lm
CC=icc

#
#  GNU compiler and BLAS implementation
#
CFLAGS=-mieee-fp -Wall -O2 -I${INTEL_MKL}/include
#CC=gcc


#LDFLAGS=-lpthread

BLASMatrixMult: BLASMatrixMult.o ../Matrix.o



#	ld BLASMatrixMult.o ../Matrix.o -o BLASMatrixMult ${LDFLAGS} -lm -lc

BLASMatrixMult.o: BLASMatrixMult.c

../Matrix.o: ../Matrix.c

clean:
	rm -f BLASMatrixMult.o ../Matrix.o
