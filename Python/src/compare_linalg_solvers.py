description = """
A short description of the program.
"""
epilog = """
This text is presented below the arguments, it is a good place to list assumptions, requirements, side effects 
or discussions of the program.  If this text here is already formatted see the argparse.RawDescriptionHelpFormatter in 
http://docs.python.org/library/argparse.html#formatter-class
"""

"""
:author: Rick Gaudette
:date: Nov 12, 2010
"""

import numpy as np

if __name__ == "__main__":
    np.set_printoptions(suppress = True, precision = 16, linewidth = 160)
    n_dim = 2
    
    A = np.array([[1.0E-10, 1E-12], [1.0, 1.0]])
                  
    x = np.ones((n_dim, 1))

    b = np.dot(A, x)
    
    print "A"
    print A
    print "x"
    print x
    print "b"
    print b
    

    x_solve = np.linalg.solve(A, b)
    print "x_solve"
    print x_solve
    

    q,r = np.linalg.qr(A)
    print "q"
    print q
    print "r"
    print r
    p = np.dot(q.transpose(), b)
    print "p"
    print p
    x_qr = np.linalg.solve(r, p)
    print "x_qr"
    print x_qr