"""
Created on Jul 7, 2010

@author: rick
"""

import numpy as np
import unittest
import sacsys.my_utilities as my_utilities
import signal_proc

class TestCircshift(unittest.TestCase, my_utilities.FormattedAssert):

    def test_list_fwd(self):
        x = [1, 2, 3, 4]
        xcs = signal_proc.circshift(x, 1)
        self.formatted_assert_equal("Circular shift did not return the expected array", [4, 1, 2, 3], xcs)

    def test_list_rev(self):
        x = [1, 2, 3, 4]
        xcs = signal_proc.circshift(x, -2)
        self.formatted_assert_equal("Circular shift did not return the expected array", [3, 4, 1, 2], xcs)

    def test_1D_array_fwd(self):
        x = np.array([1, 2, 3, 4])
        xcs = signal_proc.circshift(x, 1)
        self.formatted_assert_equal("Circular shift did not return the expected array", np.array([4, 1, 2, 3]), xcs)

    def test_1D_array_rev(self):
        x = np.array([1, 2, 3, 4])
        xcs = signal_proc.circshift(x, -1)
        self.formatted_assert_equal("Circular shift did not return the expected array", np.array([2, 3, 4, 1]), xcs)

    def test_2D_array_scalar_shift_fwd_null(self):
        expected = np.array([[8, 9, 10, 11],
                             [0, 1, 2, 3],
                             [4, 5, 6, 7]])
        x = np.arange(0,12).reshape(3,4)
        xcs = signal_proc.circshift(x, [1, 0])
        np.testing.assert_array_equal(expected, xcs, "Circular shift did not return the expected array")

    def test_2D_array_scalar_shift_null_fwd(self):
        expected = np.array([[3, 0, 1, 2],
                             [7, 4, 5, 6],
                             [11, 8, 9, 10]])
        x = np.arange(0,12).reshape(3,4)
        xcs = signal_proc.circshift(x, [0, 1])
        np.testing.assert_array_equal(expected, xcs, "Circular shift did not return the expected array")

    def test_2D_array_scalar_shift_fwd_fwd(self):
        expected = np.array([[11, 8, 9, 10],
                             [3, 0, 1, 2],
                             [7, 4, 5, 6]])
        x = np.arange(0,12).reshape(3,4)
        xcs = signal_proc.circshift(x, [1, 1])
        np.testing.assert_array_equal(expected, xcs, "Circular shift did not return the expected array")

    def test_2D_array_scalar_shift_fwd_rev(self):
        expected = np.array([[9, 10, 11, 8],
                             [1, 2, 3, 0],
                             [5, 6, 7, 4]])
        x = np.arange(0,12).reshape(3,4)
        xcs = signal_proc.circshift(x, [1, -1])
        np.testing.assert_array_equal(expected, xcs, "Circular shift did not return the expected array")

    def test_2D_array_scalar_shift_rev_fwd(self):
        expected = np.array([[7, 4, 5, 6],
                             [11, 8, 9, 10],
                             [3, 0, 1, 2]])
        x = np.arange(0,12).reshape(3,4)
        xcs = signal_proc.circshift(x, [-1, 1])
        np.testing.assert_array_equal(expected, xcs, "Circular shift did not return the expected array")

    # TODO 3-D, 4-D ... arrays
        

if __name__ == "__main__":
    unittest.main()