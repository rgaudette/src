#
#  CMatrixMult makefile
#
CC=icc
CFLAGS=-O2 -tpp6 -march=pentiumii
#CFLAGS=-O3 -mcpu=athlon -march=athlon -fforce-addr -fomit-frame-pointer -funroll-loops -frerun-cse-after-loop -frerun-loop-opt -malign-functions=4 -Wall
#CFLAGS=-O3 -mcpu=i686 -march=i686 -ffast-math

LDFLAGS=-O2
#LDFLAGS=-O3 -mcpu=athlon -march=athlon -fforce-addr -fomit-frame-pointer -funroll-loops -frerun-cse-after-loop -frerun-loop-opt -malign-functions=4 -Wall
#LDFLAGS=-O3 -mcpu=i686 -march=i686 -ffast-math


CMatrixMult: CMatrixMult.o Matrix.o

CMatrixMult.o: CMatrixMult.c

Matrix.o: ../Matrix.c
	$(CC) $(CFLAGS) ../Matrix.c -c

clean:
	rm -rf *.o CMatrixMult

