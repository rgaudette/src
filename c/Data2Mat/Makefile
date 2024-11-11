##
##  Makefile for data2mat program
##

##
##  SGI
##
SYSEXT = sgi
CC = cc

##
##  SUN
##
#SYSEXT = solaris
#CC = gcc


OBJS = data2mat.o
CFLAGS = -O2 -DUNIX

DLIBS = /home/macleod/dfile/lib/datafilelib-${SYSEXT}.a \
       /home/macleod/dfile/lib/graphicsiolib-${SYSEXT}.a \
       /home/macleod/cutil/libcutil-${SYSEXT}.a


data2mat: ${OBJS}
	${CC} ${CFLAGS} ${OBJS} ${DLIBS} \
           -lm -o data2mat

clean:
	rm -f *.o

distclean:
	rm -f *.o data2mat
