"""
Created on Mar 3, 2011

@author: rick
"""

import numpy as np
import matplotlib.pyplot as plt

def decaying_average(x, weight = 0.99, weighted_sum = 0, weight_accum = 1):
    
    weighted_sum = x + weight * weighted_sum
    weight_accum = 1 + weight * weight_accum
    weighted_avg = weighted_sum / weight_accum
    return weighted_avg, weighted_sum, weight_accum

v, s, w = decaying_average(5.0)
print v, s, w

z = np.ones(10) * 5
s = 0
w = 0
for x in z:
    v, s, w = decaying_average(x, 0.99, s, w)
    print v, s, w
    
z = np.arange(20)
zr = np.arange(20,0,-1)
z2 = np.concatenate((z, zr))
f = list()
s = 0
w = 0
for x in z2:
    v, s, w = decaying_average(x, 0.99, s, w)
    f.append(v)
    print v, s, w

plt.plot(z2)
plt.plot(f)
plt.show()
