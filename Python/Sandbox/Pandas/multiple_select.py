"""Describe the module
"""
from __future__ import division

import numpy as np
import pandas as pd


def main():

    # Create a simple table that is easy to correlate with the selection criteria
    table = np.arange(32)
    table.shape = (8, 4)
    df = pd.DataFrame(table, columns=list('ABCD'))
    print "Full data frame:\n", df

    print("Extracting out a couple of columns")
    print "\ndf[['B', 'C']]\n", df[['B', 'C']]

    # We can use isin to create a boolean frame that specifies the match of
    criteria = {'A': [4, 16, 28], 'B': [5], 'C': [6, 18, 26], 'D': [7]}
    print "\nCriteria\n", criteria
    criteria_true = df.isin(criteria)
    print "\ndf.isin(criteria)"
    print criteria_true

    # Use all to find the rows where the criteria is true for all of the rows, the results is Series
    print "\ndf.isin(criteria).all(1)\n"
    row_mask_all = criteria_true.all(1)

    print row_mask_all

    print "\ndf[row_mask_all]"
    print df[row_mask_all]

    print "\ndf.isin(criteria).any(1)\n"
    row_mask_any = criteria_true.any(1)
    print row_mask_any

    print "\ndf[row_mask_any]"
    print df[row_mask_any]

    # Selecting the rows where a given columns is between a range of vales
    print "rows with values of C in the range [18,27)"
    print df[(df['C'] >= 18) & (df['C'] < 27)]

    # Adding a new row
    df['E'] = 1.0
    print df

    # Adding a new row with missing data
    df['F'] = np.NaN
    print df


if __name__ == "__main__":
    main()
