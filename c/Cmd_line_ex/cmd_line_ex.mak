#
# Makefile for cmd_line_ex.mak
#

##
##  This compiles cmd_line_ex in a two step process.  With such a simple
##  program it could really be done in one but this shows how dependencies
##  can be built between files.
##

##
##  This says that the executable cmd_line_ex depends on the cmd_line_ex.o, 
##  the tabbed line below tells make how create cmd_line_ex from cmd_line_ex.o
##
cmd_line_ex: cmd_line_ex.o
	cc  cmd_line_ex.o -o cmd_line_ex

##
##  This says that the object file cmd_line_ex.o depends on the cmd_line_ex.c
##
cmd_line_ex.o: cmd_line_ex.c
	cc -c cmd_line_ex.c
