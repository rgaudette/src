"""Describe the module
"""
from __future__ import division

import argparse
import collections
import os
import sys

import matplotlib.pyplot as plt
import numpy as np


def main():
    # x = np.arange(-5, 5, 0.05)
    # alpha = 1.0
    # a = 2.0
    # b = 2.0
    # plt.figure()
    # plt.subplot(3, 1, 1)
    # y = 1 / (1 + np.exp(- alpha * x))
    # plt.plot(x, y)
    # plt.grid(True)
    # plt.title("Normal y = (1 + exp(- alpha x)) alpha = 1.0")
    #
    # plt.subplot(3, 1, 2)
    # y = 1 / (1 + np.exp(alpha * x))
    # plt.plot(x, y)
    # plt.grid(True)
    # plt.title("Reversed y = (1 + exp(- alpha x)) alpha = - 1.0")
    #
    # plt.subplot(3, 1, 3)
    # y = a / (1 + np.exp(alpha * x)) + b
    # plt.plot(x, y)
    # plt.grid(True)
    # plt.title("Reversed scaled and offset, ")

    plt.figure()
    x = np.arange(200, 600, 10)
    x1 = 300
    y1 = 1.15
    x2 = 500
    y2 = 1.08
    beta = 400
    alpha = np.log(1 / 0.9 - 1.0) / (x1 - beta)
    print alpha
    alpha = np.log(1 / 0.1 - 1.0) / (x2 - beta)
    print alpha

    a = (y1 - y2) / 0.8
    b = y2 - 0.1 * a
    print b
    b = y1 - 0.9 * a
    print b
    y = a / (1 + np.exp(alpha * (x - beta))) + b
    plt.plot(x, y)
    plt.grid(True)
    plt.show()

if __name__ == "__main__":
    main()
