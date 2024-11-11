""" scipy.misc image reading and writing demonstration
"""
from __future__ import division

import argparse
import collections
import os
import sys

import numpy as np
import scipy.misc as spmisc

"""
:author: Rick Gaudette
:date: 2012-03-28 
"""

def main():
    im = spmisc.imread("projection_8bit.png")
    print "image data type: ", im.dtype
    print "image size: ", im.shape
    print "image min: ", np.min(im)
    print "image max: ", np.max(im)

    spmisc.imsave("imsave_8bit.png", im)

    imf = im.view('float64')
    print "image data type: ", imf.dtype
    print "image size: ", imf.shape
    print "image min: ", np.min(imf)
    print "image max: ", np.max(imf)
    spmisc.imsave("imsave_float64.png", imf)


if __name__ == "__main__":
    main()
