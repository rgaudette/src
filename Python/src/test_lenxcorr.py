"""
Created on Jul 7, 2010

@author: rick
"""
import numpy as np
import unittest
import signal_proc
np.set_printoptions(suppress=True, precision =3)

class TestLenxcorr(unittest.TestCase):

    # TODO
    # should all of these cases map to function names
    # - as the number of dimensions gets larger we an increasing number of permutations
    # border larger,smaller,equal than size of x
    # match in y, corners, center
    # ramp background
    # constant, varying pattern
    # modification of x_first and x_last
    # x and y in the frequency domain 
    def test_1D_pulse_slope(self):
        # The local energy normalized cross-correlation sequence should return a max at the shift associated with the
        # small pulse starting at index 13 of y (a lag of -13)
        x = np.array([1, 1, 1, 1])
        y = np.array([0, 0, 0, 0, 10, 9, 8, 7, 6, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0])
        
        lenccs, lag = signal_proc.lenxcorr(x, y)
        idx_peak_lenccs = np.argmax(lenccs)
        np.testing.assert_array_equal(lag[idx_peak_lenccs], -13, "Incorrect peak index")


    def test_2D_pulse(self):
        nx_i = 5
        nx_j = 4
        x = np.ones((nx_i, nx_j))
        ny_i = 10
        ny_j = 10

        # Near center
        shift_i = 3
        shift_j = 4
        self._test_shifted_copy_2D(x, (ny_i, ny_j), (shift_i, shift_j))

        # Upper left corner
        shift_i = 0
        shift_j = 0
        self._test_shifted_copy_2D(x, (ny_i, ny_j), (shift_i, shift_j))
        
        # Upper right corner
        shift_i = 0
        shift_j = ny_j - nx_j
        self._test_shifted_copy_2D(x, (ny_i, ny_j), (shift_i, shift_j))

        # Lower right corner
        shift_i = ny_i - nx_i 
        shift_j = ny_j - nx_j
        self._test_shifted_copy_2D(x, (ny_i, ny_j), (shift_i, shift_j))
        
    def _test_shifted_copy_2D(self, x, y_shape, shift):
        y = np.zeros(y_shape)
        (nx_i, nx_j) = x.shape
        y[shift[0]:shift[0]+nx_i, shift[1]:shift[1]+nx_j] = x
        lenccs, lag = signal_proc.lenxcorr(x, y)
        idx_peak_lenccs = np.unravel_index(np.argmax(lenccs), lenccs.shape)
        np.testing.assert_array_equal(lag[0][idx_peak_lenccs[0]], -shift[0], "Incorrect peak row index")
        np.testing.assert_array_equal(lag[1][idx_peak_lenccs[1]], -shift[1], "Incorrect peak column index")
