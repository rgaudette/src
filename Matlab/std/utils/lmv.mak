#
#    lmv.mak - makefile for lmv.c
#

##############################################################################
##############################################################################
##  $Author: rickg $
##
##  $Date: 2004/01/03 08:25:24 $
##
##  $Revision: 1.1.1.1 $
##
##  $Log: lmv.mak,v $
##  Revision 1.1.1.1  2004/01/03 08:25:24  rickg
##  Matlab Source
##
#  
#     Rev 1.0   22 Mar 1994 10:12:12   rjg
#  Initial revision.
##
##############################################################################
##############################################################################

#
#ARCH=hp700
ARCH=sun4
MATLAB_INCLUDE = /usr/local/matlab/extern/include
MATLAB_LIB = /usr/local/matlab/extern/lib/$(ARCH)

CC = gcc
CFLAGS = -g

lmv:lmv.c
	$(CC) $(CFLAGS) lmv.c -o lmv -I$(MATLAB_INCLUDE) \
	-L$(MATLAB_LIB) -lmat -lm
