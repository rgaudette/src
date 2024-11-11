"""Describe the module
"""
from __future__ import division

import argparse
import collections
import os
import sys

import numpy as np
import numpy.random as nprnd
import scipy.signal as spsig
import scipy.ndimage as spndi

import pywt

def main():
    n = 128
    # Create a Gaussian zero mean, unit variance image and take the swt of it
    print("Normal Zero mean, unit variance")
    im = nprnd.standard_normal((n, n))
    print("mean: {:0.2f}  std: {:0.2f}".format(np.mean(im), np.std(im)))

    IM = pywt.swt2(im, 'haar', 3)
    for level, subband in enumerate(IM):
        print("Level {} approx mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[0]), np.std(subband[0])))
        print("Level {} horizontal mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[1][0]), np.std(subband[1][0])))
        print("Level {} vertical mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[1][1]), np.std(subband[1][1])))
        print("Level {} diagonal mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[1][2]), np.std(subband[1][2])))
        print("")
    print("")

    # Create a Gaussian zero mean, std 10 image and take the swt of it
    print("Normal Zero mean, std dev = 10")
    im = nprnd.standard_normal((n, n)) * 10
    print("mean: {:0.2f}  std: {:0.2f}".format(np.mean(im), np.std(im)))

    IM = pywt.swt2(im, 'haar', 3)
    for level, subband in enumerate(IM):
        print("Level {} approx mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[0]), np.std(subband[0])))
        print("Level {} horizontal mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[1][0]), np.std(subband[1][0])))
        print("Level {} vertical mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[1][1]), np.std(subband[1][1])))
        print("Level {} diagonal mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[1][2]), np.std(subband[1][2])))
        print("")
    print("")

    # Create a Poisson lamba = 1 take the swt of it
    print("Poisson lambda = 1")
    im = nprnd.poisson(1.0, (n, n))
    print("mean: {:0.2f}  std: {:0.2f}".format(np.mean(im), np.std(im)))

    IM = pywt.swt2(im, 'haar', 3)
    for level, subband in enumerate(IM):
        print("Level {} approx mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[0]), np.std(subband[0])))
        print("Level {} horizontal mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[1][0]), np.std(subband[1][0])))
        print("Level {} vertical mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[1][1]), np.std(subband[1][1])))
        print("Level {} diagonal mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[1][2]), np.std(subband[1][2])))
        print("")
    print("")

    l = 4
    h = np.ones(l) * (1/l)

    # Create a Poisson lamba = 1.0 and convolve it with an autocorrelation function to correlate the data
    print("Poisson lambda = 1.0 correlated")
    im_corr = spndi.convolve1d(im, h, axis = 0, mode = 'wrap')

    print("mean: {:0.2f}  std: {:0.2f}".format(np.mean(im_corr), np.std(im_corr)))

    IM = pywt.swt2(im_corr, 'haar', 3)
    for level, subband in enumerate(IM):
        print("Level {} approx mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[0]), np.std(subband[0])))
        print("Level {} horizontal mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[1][0]), np.std(subband[1][0])))
        print("Level {} vertical mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[1][1]), np.std(subband[1][1])))
        print("Level {} diagonal mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[1][2]), np.std(subband[1][2])))
        print("")
    print("")

    # Create a Poisson lamba = 10, take the swt of it
    print("Poisson lambda = 10")
    im = nprnd.poisson(10.0, (n, n))
    print("mean: {:0.2f}  std: {:0.2f}".format(np.mean(im), np.std(im)))

    IM = pywt.swt2(im, 'haar', 3)
    for level, subband in enumerate(IM):
        print("Level {} approx mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[0]), np.std(subband[0])))
        print("Level {} horizontal mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[1][0]), np.std(subband[1][0])))
        print("Level {} vertical mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[1][1]), np.std(subband[1][1])))
        print("Level {} diagonal mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[1][2]), np.std(subband[1][2])))
        print("")
    print("")

    # Create a Poisson lamba = 10 and convolve it with an autocorrelation function to correlate the data
    print("Poisson lambda = 10 correlated")
    im_corr = spndi.convolve1d(im, h, axis = 0, mode = 'wrap')

    print("mean: {:0.2f}  std: {:0.2f}".format(np.mean(im_corr), np.std(im_corr)))

    IM = pywt.swt2(im_corr, 'haar', 3)
    for level, subband in enumerate(IM):
        print("Level {} approx mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[0]), np.std(subband[0])))
        print("Level {} horizontal mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[1][0]), np.std(subband[1][0])))
        print("Level {} vertical mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[1][1]), np.std(subband[1][1])))
        print("Level {} diagonal mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[1][2]), np.std(subband[1][2])))
        print("")
    print("")

    # Create a Poisson lamba = 100, take the swt of it
    print("Poisson lambda = 100")
    im = nprnd.poisson(100.0, (n, n))
    print("mean: {:0.2f}  std: {:0.2f}".format(np.mean(im), np.std(im)))

    IM = pywt.swt2(im, 'haar', 3)
    for level, subband in enumerate(IM):
        print("Level {} approx mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[0]), np.std(subband[0])))
        print("Level {} horizontal mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[1][0]), np.std(subband[1][0])))
        print("Level {} vertical mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[1][1]), np.std(subband[1][1])))
        print("Level {} diagonal mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[1][2]), np.std(subband[1][2])))
        print("")
    print("")

    # Create a Poisson lamba = 100 and convolve it with an autocorrelation function to correlate the data
    print("Poisson lambda = 100 correlated")
    im_corr = spndi.convolve1d(im, h, axis = 0, mode = 'wrap')

    print("mean: {:0.2f}  std: {:0.2f}".format(np.mean(im_corr), np.std(im_corr)))

    IM = pywt.swt2(im_corr, 'haar', 3)
    for level, subband in enumerate(IM):
        print("Level {} approx mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[0]), np.std(subband[0])))
        print("Level {} horizontal mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[1][0]), np.std(subband[1][0])))
        print("Level {} vertical mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[1][1]), np.std(subband[1][1])))
        print("Level {} diagonal mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[1][2]), np.std(subband[1][2])))
        print("")
    print("")

    # Create a Poisson lamba = 100 scale it by 0.1, take the swt of it
    print("Poisson lambda = 100 scaled by 0.1")
    im = nprnd.poisson(100.0, (n, n)) * 0.1
    print("mean: {:0.2f}  std: {:0.2f}".format(np.mean(im), np.std(im)))

    IM = pywt.swt2(im, 'haar', 3)
    for level, subband in enumerate(IM):
        print("Level {} approx mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[0]), np.std(subband[0])))
        print("Level {} horizontal mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[1][0]), np.std(subband[1][0])))
        print("Level {} vertical mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[1][1]), np.std(subband[1][1])))
        print("Level {} diagonal mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[1][2]), np.std(subband[1][2])))
        print("")
    print("")


    # Create a Poisson lamba = 100 and convolve it with an autocorrelation function to correlate the data
    print("Poisson lambda = 100 scaled by 0.1 correlated")
    im_corr = spndi.convolve1d(im, h, axis = 0, mode = 'wrap')

    print("mean: {:0.2f}  std: {:0.2f}  subsampled std: {:0.2f}".format(np.mean(im_corr), np.std(im_corr), np.std(im[::l,::l])))

    IM = pywt.swt2(im_corr, 'haar', 3)
    for level, subband in enumerate(IM):
        print("Level {} approx mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[0]), np.std(subband[0])))
        print("Level {} horizontal mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[1][0]), np.std(subband[1][0])))
        print("Level {} vertical mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[1][1]), np.std(subband[1][1])))
        print("Level {} diagonal mean: {:0.2f}  std: {:0.2f}".format(level+1, np.mean(subband[1][2]), np.std(subband[1][2])))
        print("")
    print("")

if __name__ == "__main__":

    main()
