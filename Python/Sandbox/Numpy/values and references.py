"""Show the differences between assignment and copying
"""

from numpy import *

def main():
    a = full(3, 3)
    print("a", a)
    # assignment creates a new reference, not a cop
    b = a
    print("b", b)
    b[0] = 0
    print("a", a)
    print("b", b)

    # copy as expected creates a new copy
    c = copy(a)
    c[0] = 1
    print("a", a)
    print("c", c)

    # since python is pass by reference, array elements can be modified in functions
    modify_arg(a)
    print("a", a)

    modify_reference(a)
    print("a", a)

    inplace_multiply(a)
    print("a", a)

def modify_arg(v):
    v[0] = 4

def modify_reference(v):
    # reassigning v to a new array object will not change the name v in the caller
    v = v * 2
    print("v", v)

def inplace_multiply(v):
    v *= 3

if __name__ == "__main__":
    main()