"""Describe the module
"""
from __future__ import division

import argparse
import collections
import os
import sys

import matplotlib.pyplot as plt
import numpy as np
import scipy.optimize as spopt

import numpy.testing as npt

def cost(theta, x, y):
    # theta[0]: r
    # theta[1]: m
    # want to minimize sum over (x,y) (y - 2 * sqrt(theta[0] ** 2 - (x - theta[1]) ** 2)) ** 2
    # print "theta:", theta
    # print "x - theta:", (x - theta[1])
    resid = y - 2 * np.sqrt(theta[0] ** 2 - (x - theta[1]) ** 2)
    err = np.sum(resid ** 2)
    return err


def main():
    diameter_estimate = np.array([276.3,  353.9,  414.6,  451.9,  476.5,  472.5, 448.8,  401.4,  343.4])
    offset = np.array([-203.2, -152.4, -101.6,  -50.8,    0. ,   50.8, 101.6,  152.4,  203.2])

    # plt.figure(1)
    # resid_250_0 = diameter_estimate - 2 * np.sqrt(250.0 ** 2 - (offset - 0.0) ** 2)
    # plt.plot(offset, resid_250_0)
    # plt.draw()
    # plt.show()

    #params = spopt.minimize(cost, [250.0, 0.0], method='L-BFGS-B', args = (offset, diameter_estimate), bounds=(200.0, 300.0))
    # Possible optimization techniques without supplying the jacobian or hessian: 'Nelder-Mead', 'Powell', 'COBYLA'
    params = spopt.minimize(cost, [250.0, 0.0], args=(offset, diameter_estimate), method='Nelder-Mead')
    #print params.x

    offset = np.array([-101.6,  -50.8,    0. ,   50.8,  101.6])
    diameter_estimate = np.array([220.1,  258.3,  269.6,  238.4,  187.2])


    offset = np.array([-101.6,  -50.8,    0. ,   50.8,  101.6])
    diameter_estimate = np.array([238.5,  269.5,  270.4,  234.2,  175.3]) + 30.0
    params = spopt.minimize(cost, [150.0, 0.0], args=(offset, diameter_estimate), method='Nelder-Mead')
    print params

if __name__ == "__main__":
    main()
