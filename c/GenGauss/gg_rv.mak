#!/bin/make

#
#CFLAGS = -O3 -ansi
CFLAGS = -O3 -ansi -D__NO_MATH_INLINES -Wall -m486 -static
#CFLAGS  = -g -ansi -static -Wall -m486
CC 	= gcc

OBJS = gg_rv.o gamma.o unif_rng.o

gengauss:  ${OBJS}
	${CC} ${CFLAGS} ${OBJS} -lm -o gengauss

gg_rv.o: gg_rv.c
	${CC} ${CFLAGS} -c gg_rv.c

gamma.o: gamma.c
	${CC} ${CFLAGS} -c gamma.c

unif_rng.o: unif_rng.c
	${CC} ${CFLAGS} -c unif_rng.c

