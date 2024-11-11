#
#CFLAGS = -O3 -ansi
CFLAGS =  -ansi -g -O
CC 	= gcc

INCDIR = /usr/local/mitdb/include
DBLIBDIR = /usr/local/mitdb/lib

OBJS = psamples.o

psamples: ${OBJS}
	${CC} ${CFLAGS} ${OBJS} -L${DBLIBDIR} -ldb -o psamples

psamples.o: psamples.c
	${CC} ${CFLAGS} -I${INCDIR} -c psamples.c


clean:
	rm -f ${OBJS} psamples
