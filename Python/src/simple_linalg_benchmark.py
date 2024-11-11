"""
A simple linear algebra benchmark
"""
import time
import numpy as np
from numpy import *

# Small in cache multiply
m_x = 256
n_x = m_x
m_y = n_x
n_y = m_x
nflop = n_y * m_y * (n_x + n_x - 1)
size_x = (m_x, m_y)
size_y = (n_x, n_y)
x = np.random.normal(size = size_x)
y = np.random.normal(size = size_y)
 
i = 0
n_loops = 1000000
# unroll by 10 to minimize the loop effect
x_loops =  n_loops/10
st = time.clock()
for i in xrange(x_loops):
    z = dot(x, y)
    z = dot(x, y)
    z = dot(x, y)
    z = dot(x, y)
    z = dot(x, y)
    z = dot(x, y)
    z = dot(x, y)
    z = dot(x, y)
    z = dot(x, y)
    z = dot(x, y)

end = time.clock()

dur = end - st
print("{0}  {1} x {2} matrix multiply: {3:0.4f} secs  {4:0.4f} GFLOPS".format(n_loops, 
                                                                              size_x, 
                                                                              size_y, 
                                                                              end - st, 
                                                                              nflop * n_loops / dur / 1E9))


#  Out of cache multiply
m_x = 5000
n_x = m_x
m_y = n_x
n_y = m_x
nflop = n_y * m_y * (n_x + n_x - 1)
size_x = (m_x, m_y)
size_y = (n_x, n_y)
x = np.random.normal(size = size_x)
y = np.random.normal(size = size_y)
 
st = time.clock()
z = np.dot(x, y)
end = time.clock()
dur = end - st
print("{0} x {1} matrix multiply: {2:0.4f} secs  {3:0.4f} GFLOPS".format(size_x, size_y, end - st, nflop / dur / 1.0E9))

# SVD
m_x = 1000
m_y = 1000
size_x = (m_x, m_y)
x = np.random.normal(size = size_x)
 
st = time.clock()
u, s, vt = np.linalg.svd(x)
end = time.clock()
dur = end - st
print("{0} SVD: {1:0.4f} secs".format(size_x, end - st))