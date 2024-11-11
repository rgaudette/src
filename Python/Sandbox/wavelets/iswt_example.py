from __future__ import division

from numpy import *
from pywt import *
from matplotlib.pyplot import *
import laboratory.mm_iswt as mm_iswt

x = array([ 0.25530595,  0.16997079, -1.84997225,  1.14097786,  0.17890838,
            -1.29713507, -0.34009756, -0.19392772, -0.82824316,  0.86255438,
            0.93284644,  0.78180299, -0.23144982,  1.50151715, -0.85447897,
            -1.20341503])

x_swt = swt(x, 'haar', 3)

x_iswt = mm_iswt.iswt(x_swt, 'haar')

plot(x, 'b')
plot(x_iswt, 'r')
show()

