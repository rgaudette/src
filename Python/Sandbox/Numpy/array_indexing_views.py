from __future__ import division

from numpy import *

def mod_formal_parameter(param):
    param = param[1:-1]
    return param

print "array"
a = arange(5)
print a
# indexing does not create a new copy but a view into the array object
b = a[1:-1]
print b
# changing the elements of the view changes the
b[1] = -1
print b
print a

print "list"
la = range(5)
print la
lb = la[1:-1]
print lb
lb[1] = -1
print lb
print la

#p = mod_formal_parameter(a)
#print a
#print p

