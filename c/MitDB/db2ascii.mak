#
CFLAGS = -O3 -ansi -static 
CC 	= gcc

OSNAME = SunOS5
INCDIR = /usr/local/mitdb/include
DBLIBDIR = /usr/local/mitdb/lib

OBJS = db2ascii.o

db2ascii: ${OBJS}
	${CC} ${CFLAGS} ${OBJS} -L${DBLIBDIR} -ldb -o db2ascii

db2ascii.o: db2ascii.c
	${CC} ${CFLAGS} -I${INCDIR} -c db2ascii.c


clean:
	rm -f ${OBJS} db2ascii
