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
import pandas as pd

def main():


    # Create a simple table that is easy to correlate with the selection criteria
    table = np.arange(32)
    table.shape = (8, 4)
    df = pd.DataFrame(table, columns=['a', 'b', 'c', 'd'])
    print df
    print df.dtypes

    # Convert c to floats
    col_c = df['c'].astype(float)

    df['c'] = col_c

    print df
    print df.dtypes

if __name__ == "__main__":
    main()
