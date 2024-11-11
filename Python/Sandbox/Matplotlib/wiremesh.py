"""Describe the module
"""
from __future__ import division

from mpl_toolkits.mplot3d import axes3d
import matplotlib.pyplot as plt
import numpy as np

def main():

    plt.ion()

    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    X, Y, Z = axes3d.get_test_data(0.1)
    ax.plot_wireframe(X, Y, Z, rstride=5, cstride=5)

    plt.show()

#    for angle in range(0, 360):
#        ax.view_init(30, angle)
#        plt.draw()

if __name__ == "__main__":
    main()
