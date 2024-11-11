__author__ = 'rick'
import numpy as np
a_int = np.array([4, 0, 9, -3, 9])
print a_int
a_int_idx = np.arange(len(a_int))
print a_int_idx
a_int_argsort = np.argsort(a_int)
print np.argsort(a_int)
print a_int_idx`[a_int_argsort]
