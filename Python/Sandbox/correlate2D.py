from __future__ import division

import matplotlib
import matplotlib.pyplot as plt
import numpy as np
import scipy.signal as spsig

description = """
A short description of the program.
"""
epilog = """
This text is presented below the arguments, it is a good place to list assumptions, requirements, side effects
or discussions of the program.  If this text here is already formatted see the argparse.RawDescriptionHelpFormatter in
http://docs.python.org/library/argparse.html#formatter-class
"""

"""
:author: 
:date: 
"""

def main():
    cmap = matplotlib.cm.get_cmap('gray')
    ref = np.ones((12,12))
    test = np.ones((16,16))
    test[0:2,:] = 0.0
    test[14:16,:] = 0.0
    test[:, 0:2] = 0.0
    test[:, 14:16] = 0.0
    xc = np.abs(spsig.correlate2d(test, ref, mode = 'valid'))

    peak_idx = np.argmax(xc)
    print np.unravel_index(peak_idx, xc.shape)
    plt.figure()
    plt.imshow(xc, cmap = cmap, aspect = 'equal', interpolation = 'nearest')

    plt.show()
    
if __name__ == "__main__":
    main()  