"""Describe the module
"""

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
import scipy.sparse as spspar
import scipy.ndimage as spndi
import numpy.testing as npt


def main():

    A_1 = np.eye(3)
    A_2 = np.arange(12)
    A_2.shape = (3, 4)
    list_of_dense_arrays = list([A_1, A_2])

    np.savez("list_of_arrays.npz",
             list_of_dense_arrays=list_of_dense_arrays)
    variables = np.load("list_of_arrays.npz")
    lda_in = variables["list_of_dense_arrays"]
    print(lda_in)
    print(type(lda_in))



if __name__ == "__main__":
    main()
