"""Describe the module
"""
from __future__ import division

import argparse
import collections
import os
import sys

import matplotlib.pyplot as plt
import numpy as np
import scipy as sp
import scipy.linalg as spla
import scipy.misc as spmisc
import scipy.signal as spsig
import scipy.special as spspec
import scipy.ndimage as spndi
import numpy.testing as npt
import pywt

z = np.array([[0, 0, 0, 0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0, 0, 0, 0],
              [0, 0, 1, 1, 1, 1, 0, 0],
              [0, 0, 1, 1, 1, 0, 0, 0],
              [0, 0, 1, 1, 0, 0, 0, 0],
              [0, 0, 1, 0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0, 0, 0, 0]
             ])
print z
unit_haar = pywt.Wavelet('unit haar', [[1.0, 1.0], [-1.0, 1.0], [0.5, 0.5], [0.5, -0.5]])
coeffs = pywt.swt2(z, 'haar', 1)
print "approx"
print coeffs[0][0]

print "horizontal"
print coeffs[0][1][0]

print "vertical"
print coeffs[0][1][1]

print "diagonal"
print coeffs[0][1][2]