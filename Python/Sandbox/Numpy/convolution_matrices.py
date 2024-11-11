"""Examples of convolution matrices, both dense and sparse
"""
from __future__ import division
import numpy as np
import numpy.testing as npt
import scipy.linalg as spla
import scipy.signal as spsig
import scipy.sparse

np.set_printoptions(precision=2, linewidth=160)
show_data = False
def main():

    n_impulse = 1024
    impulse = np.arange(1.0, n_impulse + 1.0)

    n_x = 128
    x = np.arange(1.0, n_x + 1.0)
    print_array_info(x, name='x', show_data=show_data)

    # Convolution function from the scipy.signal package
    y_conv = spsig.convolve(impulse, x, mode='full')

    # Compute the full convolution using a matrix representation given the signal and impulse are zero outside the
    # specified data
    n_row = n_impulse + n_x - 1
    A_dense = lsi_operator(impulse, n_row, n_x)
    print_array_info(A_dense, name='A_dense', show_data=show_data)

    y_lin_op = np.dot(A_dense, x)
    print_array_info(y_lin_op, name='y_lin_op', show_data=show_data)

    npt.assert_array_equal(y_lin_op, y_conv)

    # If the length of h is significantly less than the length of x, then the linear operator matrix is a sparse
    # Toeplitz matrix. Using scipy sparse matrices should speed up the matrix-vector multiply
    A_sparse = scipy.sparse.dia_matrix(A_dense)
    print_array_info(A_sparse, name='A_sparse', show_data=show_data)

    # dot does not return the expected size vector
    #
    y_sparse_lin_op = np.dot(A_sparse, x)
    print_array_info(y_sparse_lin_op, name='y_sparse_lin_op', show_data=show_data)
    print("""numpy.dot does not correctly hand sparse matrices!!!
    It returns an ndarray of objects that do not have the correct values""")

    y_sparse_lin_op1 = A_sparse.dot(x)
    print_array_info(y_sparse_lin_op1, name='y_sparse_lin_op1', show_data=show_data)
    npt.assert_array_equal(y_sparse_lin_op1, y_conv)

    y_sparse_lin_op2 = A_sparse * x
    print_array_info(y_sparse_lin_op2, name='y_sparse_lin_op2', show_data=show_data)
    npt.assert_array_equal(y_sparse_lin_op2, y_conv)


def lsi_operator(impulse, n = None, m = None):
    if n is None:
        n = 2 * len(impulse) - 1
    if m is None:
        m = len(impulse)

    # Create linear system representation of the convolution operator
    first_col = np.concatenate((impulse, np.zeros((n - len(impulse),))))
    row = np.zeros(m)
    row[0] = impulse[0]
    A = spla.toeplitz(first_col, row)
    return A

#def sparse_lsi
def print_array_info(a, name=None, show_data=False):
    if name is not None:
        print(name)
    print("Type: {}".format(a.__class__))
    print("Element data type: {}".format(a.dtype))
    print("Shape: {}  size: {:,d}  bytes used: {:,d}".format(a.shape, a.size, a.size * a.dtype.itemsize))
    if show_data:
        print(a)
    print("")
if __name__ == "__main__":
    main()
