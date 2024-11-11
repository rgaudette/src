"""Describe the module
"""
from __future__ import division

import argparse
import collections
import os
import sys

import numpy as np
import pandas as pd


def main():
    # Create a simple table that is easy to correlate with the selection criteria
    table = np.arange(32)
    table.shape = (8, 4)
    df = pd.DataFrame(table, columns=list('ABCD'))
    df['Cat'] = ['a','a','a','a','b','b','b','b',]

    print "Full data frame:\n", df

    bool_idx = df.Cat == 'a'

    df.loc[bool_idx, 'A'] = [1,2,3,4]
    print df
    #print df


if __name__ == "__main__":
    main()
