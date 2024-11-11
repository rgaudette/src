"""Describe the module
"""
from __future__ import division

import unittest

import numpy as np
import numpy.testing as npt
import scipy.sparse.linalg as spspla


description = __doc__
epilog = """
"""


def create_toeplitz_matrix(row, nRows):
    n_toeplitz_elements = len(row)
    n_columns = n_toeplitz_elements + nRows - 1
    matrix = np.zeros((nRows, n_columns))
    for i_row in np.arange(nRows):
        matrix[i_row, i_row:i_row+n_toeplitz_elements] = row

    return matrix


def basic_conjugate_gradients(A, b, x, n_iter, epsilon):
    i = 0
    r = b - np.dot(A, x)
    d = r
    d_new = np.dot(r.transpose(), r)
    d_0 = d_new
    while d_new > epsilon ** 2 * d_0:
        q = np.dot(A, d)
        alpha = d_new / np.dot(d.transpose(), q)
        x = x + alpha * d
        i = i + 1
        if i == n_iter:
            return x, i

        if i % 50:
            r = b - np.dot(A, x)
        else:
            r = r - alpha * q

        d_old = d_new
        d_new = np.dot(r.transpose(), r)
        beta = d_new / d_old
        d = r + beta * d

    return x, i


def normal_equation_conjugate_gradients(A, b, x, n_iter, epsilon):
    i = 0
    r = np.dot(A.transpose(), b) - np.dot(A.transpose(), np.dot(A, x))
    #print "r"
    #print r
    d = r
    d_new = np.dot(r.transpose(), r)
    d_0 = d_new
    while d_new > epsilon ** 2 * d_0:
        Ad = np.dot(A, d)
        #print "A"
        #print A
        #print "d"
        #print d
        #print "Ad"
        #print Ad
        q = np.dot(A.transpose(), Ad)
        #print "q"
        #print q

        ad_dot_ad = np.dot(Ad.transpose(), Ad)
        #print "ad_dot_ad"
        #print ad_dot_ad

        alpha = d_new / ad_dot_ad
        x = x + alpha * d
        i = i + 1
        if i == n_iter:
            return x, i

        if i % 50:
            r = np.dot(A.transpose(), b) - np.dot(A.transpose(), np.dot(A, x))
        else:
            r = r - alpha * q

        d_old = d_new
        d_new = np.dot(r.transpose(), r)
        beta = d_new / d_old
        d = r + beta * d

    return x, i


class RTCGTest(unittest.TestCase):

    def test_short_triangle_row_1_iteration(self):

        nRowsMax = 10
        nTopelitzElements = 3
        iMax = 1
        toeplitz_row = np.array((1.0, 3.0, 1.0))
        #print("toeplitz_row")
        #print toeplitz_row

        b = np.arange(1, nRowsMax + 1)
        b.shape = (nRowsMax, 1)
        #print("b")
        #print b

        nColumns = nRowsMax + nTopelitzElements - 1
        xEstimate = np.zeros((nColumns, 1))

        toeplitz_matrix = create_toeplitz_matrix(toeplitz_row, nRowsMax)
        #print toeplitz_matrix
        ATA = np.dot(toeplitz_matrix.transpose(), toeplitz_matrix)
        ##print ATA
        ATb = np.dot(toeplitz_matrix.transpose(), b)

        x_out_basic, iterations = basic_conjugate_gradients(ATA, ATb, xEstimate, iMax, 0.0)
        #print("basic cg estimate:")
        #print x_out_basic

        x_out_spspla, iterations = spspla.cg(ATA, ATb, x0=xEstimate, maxiter=iMax)
        x_out_spspla.shape = (nColumns, 1)
        #print("sparse linalg estimate:")
        #print x_out_spspla

        #print "All elements equal:", np.all(x_out_spspla.transpose() == x_out_basic)

        x_out_normal_eq, iterations = normal_equation_conjugate_gradients(toeplitz_matrix, b, xEstimate, iMax, 0.0)
        npt.assert_array_almost_equal(x_out_normal_eq, x_out_basic)
        #print "All elements equal:", np.all(x_out_normal_eq == x_out_basic)
        print("normal equation cg estimate:")
        x_out_normal_eq.shape = (nColumns,)
        print x_out_normal_eq.transpose()

    def test_short_triangle_row_2_iterations(self):
        print "test 2"
        nRowsMax = 10
        nTopelitzElements = 3
        iMax = 2

        toeplitz_row = np.array((1.0, 3.0, 1.0))
        #print("toeplitz_row")
        #print toeplitz_row

        b = np.arange(1, nRowsMax + 1)
        b.shape = (nRowsMax, 1)
        #print("b")
        #print b

        nColumns = nRowsMax + nTopelitzElements - 1
        xEstimate = np.zeros((nColumns, 1))

        toeplitz_matrix = create_toeplitz_matrix(toeplitz_row, nRowsMax)
        #print toeplitz_matrix
        ATA = np.dot(toeplitz_matrix.transpose(), toeplitz_matrix)
        ##print ATA
        ATb = np.dot(toeplitz_matrix.transpose(), b)

        x_out_basic, iterations = basic_conjugate_gradients(ATA, ATb, xEstimate, iMax, 0.0)
        #print("basic cg estimate:")
        #print x_out_basic

        x_out_spspla, iterations = spspla.cg(ATA, ATb, x0=xEstimate, maxiter=iMax)
        x_out_spspla.shape = (nColumns, 1)
        #print("sparse linalg estimate:")
        #print x_out_spspla

        #print "All elements equal:", np.all(x_out_spspla.transpose() == x_out_basic)

        x_out_normal_eq, iterations = normal_equation_conjugate_gradients(toeplitz_matrix, b, xEstimate, iMax, 0.0)
        npt.assert_array_almost_equal(x_out_normal_eq, x_out_basic)#,
                                      #"Normal equation CG does not equal basic_cg on the normal equations")
        print("normal equation cg estimate:")
        x_out_normal_eq.shape = (nColumns,)
        print x_out_normal_eq.transpose()


def main():
    #short_triangle_row_1_iteration()
    #short_triangle_row_2_iterations()
    unittest.main()

if __name__ == "__main__":
    main()
