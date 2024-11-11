from __future__ import division

import matplotlib.pyplot as plt
import numpy as np

good = np.array([35.1333709,  1.20361562,  0.76352112,  0.59435114,  0.52110856])
good = np.arange(5,0,-1)
plt.figure(1)
plt.semilogy(good)

plt.figure(1)
plt.semilogy(good)

#Problematic array
bad = np.array([ 3.51333709,  1.20361562,  0.76352112,  0.59435114,  0.52110856])
plt.figure(2)
plt.semilogy(bad)
plt.show()
