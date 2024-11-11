from __future__ import division

import numpy as np
an_array = np.arange(4)
print an_array.dtype
print an_array

# Change the type of the underlying array (this create a copy?)
an_array = an_array.astype(float)
print an_array.dtype
print an_array

# this causes wrapping so be careful, probably need to bound between 0 and 255
float_array = np.array([-1.0, 0.0, 1.0, 255.0, 256.0])
print float_array.dtype
oor = float_array.astype(np.uint8)
print oor.dtype
print oor
