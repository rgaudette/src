from __future__ import division

"""
:author: Rick Gaudette
:date: 2011-08-19 
"""

import numpy as np

# A simple 3D point dtype
dt_3d = np.dtype([('x', np.float), ('y', np.float), ('z', np.float)])

array_3d = np.array([(1,2,3), (-1,-2,-3)], dtype = dt_3d)

# Use key notation instead of dot notation to access fields
print array_3d['x']
print array_3d['y']
print array_3d['z']

dt_2d_val = np.dtype([('x', np.float), ('y', np.float), ('s', 'a5')])
array_2d_label = np.array([(1,2,'a'), (-1,-2,'b')], dtype = dt_2d_val)

# Use key notation instead of dot notation to access fields
print array_2d_label['x']
print array_2d_label['y']
print array_2d_label['s']

print len(array_2d_label)

print np.max(array_2d_label['x'])

# Modify an element
array_2d_label['x'] = -3
print np.max(array_2d_label['x'])


# A more complex array Structured Array
labeled_float_array = np.dtype([('lbl', 'a10'), ('f', np.float), ('a', np.float, (2,2))])

cmplx_array = np.zeros((2, 1), dtype = labeled_float_array)
cmplx_array[0] = ('label 0', 3.14, [[1.0,2.0],[3.0,4.0]])
cmplx_array[1] = ('this label is too long', -3, [[1,1],[1,1]])
print cmplx_array
# Addressing the
cmplx_array[1]['lbl'] = 'fixed'
print cmplx_array
cmplx_array['lbl'][1] = 'again'
print cmplx_array