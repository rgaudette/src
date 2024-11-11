"""Describe the module

:author: Rick Gaudette
:date: 2019-12-30 
"""
import sys

import matplotlib.pyplot as plt

if __name__ == '__main__':
    print('python version: ', sys.version)
    fig = plt.figure()
    print('dpi: ', fig.dpi)


