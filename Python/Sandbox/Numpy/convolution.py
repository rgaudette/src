from __future__ import division

import numpy as np
import scipy.signal as spsig
import scipy.ndimage as spndi

a = np.arange(1, 5)
print a
b = np.arange(1, 9)
print b
nc = np.convolve(a, b)
print nc

sc = spsig.convolve(a, b)
print sc

sfc = spsig.fftconvolve(a, b)
print sfc

nc = spndi.convolve1d(a, b)
print nc

c = np.vstack((b, b))
print c

nc = spndi.convolve1d(c, a, axis = 0)

print nc

a_row = [[0, 0, 0], [1, 1, 1], [0, 0, 0]]

h_row = [1, 2, 3]

ah0 = spndi.convolve1d(a_row, h_row, axis=0)
print 'axis = 0'
print ah0
ah1 = spndi.convolve1d(a_row, h_row, axis=1)
print 'axis = 1'
print ah1
