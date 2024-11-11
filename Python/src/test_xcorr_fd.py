"""
Created on Jul 7, 2010

@author: rick
"""
import numpy as np
import unittest
import sacsys.my_utilities as my_utilities
import signal_proc

np.set_printoptions(suppress=True)

class TestXcorrFD(unittest.TestCase, my_utilities.FormattedAssert):


    def test_1D_non_padded(self):
        x = np.array([1, 2, 3, 4])
        y = np.array([1, 2, 3, 4, 0, 0, 0, 0, 0, 0])
        self._test_1D(x, y, 0, '1-D no shift non-padded x test')

        y = np.array([0, 0, 1, 2, 3, 4, 0, 0, 0, 0])
        self._test_1D(x, y, -2, '1-D -2 non-padded x test')

        y = np.array([0, 0, 0, 0, 0, 0, 1, 2, 3, 4])
        self._test_1D(x, y, -6, '1-D -6 non-padded x test')

    def test_1D_padded(self):
        x = np.array([0, 0, 1, 2, 3, 4, 0, 0])
        y = np.array([1, 2, 3, 4, 0, 0, 0, 0, 0, 0])
        self._test_1D(x, y, 2, '1-D 2 padded x test', 3, 6)

        y = np.array([0, 0, 1, 2, 3, 4, 0, 0, 0, 0])
        self._test_1D(x, y, 0, '1-D 0 shift padded x test', 3, 6)

        y = np.array([0, 0, 0, 0, 0, 0, 1, 2, 3, 4])
        self._test_1D(x, y, -4, '1-D full shift padded x test', 3, 6)

    def test_1D_different_signal(self):
        x = np.array([1, 1, 1, 1])
        y = np.array([10, 9, 8, 7, 6, 0, 0, 0, 0, 1, 1, 1, 1])
#        print
#        print x
#        print y

        r, l = signal_proc.xcorr_fd(x, y)
#        print "FD xcorr"
#        print r
#        print l
        
        rxc = np.correlate(x, y, mode = "full", old_behavior = False)
        lagxc = np.arange(-len(y) + 1, len(x))
#        print "Full correlation"
#        print rxc
#        print lagxc
        
        # Select the elements that align with the range produced by the FD xcorr
        idx_first = np.argwhere(l[0] == lagxc)
        idx_last = np.argwhere(l[-1] == lagxc)
        lagxc = lagxc[idx_first:idx_last + 1]
        rxc = rxc[idx_first:idx_last + 1]
#        print "range matched with FD xcorr"
#        print rxc
#        print lagxc
        np.testing.assert_array_almost_equal(r, rxc, err_msg = "Correlation functions are not equal")
        np.testing.assert_array_almost_equal(l, lagxc, err_msg = "Correlation functions are not equal")
        
        
    def test_2D(self):
        sig_template = np.arange(1,10).reshape(3,3)
        
        test_label = '2-D no shift test'
        x = np.zeros((5,5))
        x[1:4, 1:4] = sig_template
        y = np.zeros((5,5))
        y[1:4, 1:4] = sig_template
        expected_max_lag = [0, 0]
        x_low = np.array([2, 2])
        x_high = np.array([4, 4])
        self._test_2D(x, y, expected_max_lag, test_label, x_low, x_high)

        test_label = '2-D 1,0 shift padded x test'
        x = np.zeros((5,5))
        x[1:4, 1:4] = sig_template
        y = np.zeros((5,5))
        y[0:3, 1:4] = sig_template
        expected_max_lag = [1, 0]
        x_low = np.array([2, 2])
        x_high = np.array([4, 4])
        self._test_2D(x, y, expected_max_lag, test_label, x_low, x_high)
 
        test_label = '2-D -2,1 shift padded x test'
        x = np.zeros((5,5))
        x[1:4, 1:4] = sig_template
        y = np.zeros((6,6))
        y[3:6, 0:3] = sig_template
        expected_max_lag = [-2, 1]
        x_low = np.array([2, 2])
        x_high = np.array([4, 4])
        self._test_2D(x, y, expected_max_lag, test_label, x_low, x_high)

        test_label = '2-D -3,-3 shift padded x test'
        x = np.zeros((5,5))
        x[1:4, 1:4] = sig_template
        y = np.zeros((7,7))
        y[4:7, 4:7] = sig_template
        expected_max_lag = [-3,-3]
        x_low = np.array([2, 2])
        x_high = np.array([4, 4])
        self._test_2D(x, y, expected_max_lag, test_label, x_low, x_high)

    def _test_1D(self, x, y, expected_max_lag, test_label, x_first = None, x_last = None):
        #print
        #print test_label
        #print x
        #print y
        #print x_first
        #print x_last
        
        r, l = signal_proc.xcorr_fd(x, y, x_first, x_last)
#        self._print_corr_and_lags(r, l, "Frequency domain xcorr")
        
        idx = np.argmax(r)
        #print(idx)
        #print(r[idx])
        #print(l[idx])
        self.assertEqual(expected_max_lag, l[idx], test_label)

    def _print_corr_and_lags(self, r, lags, label):
        print
        print(label)
        print("Correlation sequence:")
        print(r)
        print("Lag sequence:")
        print(lags)
        
    def _test_2D(self, x, y, expected_max_lag, test_label, x_first, x_last):
        #print
        #print test_label
        #print x
        #print y
        #print x_first
        #print x_last
        r, lags = signal_proc.xcorr_fd(x, y, x_first, x_last)
        lr = lags[0]
        lc = lags[1]
        #print r
        #print lr
        #print lc 

        max_lag = np.unravel_index(np.argmax(r), r.shape)
        #print(max_lag)
        #print(lr[max_lag[0]])
        #print(lc[max_lag[1]])

        self.assertEqual(expected_max_lag[0], lr[max_lag[0]], test_label)
        self.assertEqual(expected_max_lag[1], lc[max_lag[1]], test_label)


if __name__ == "__main__":
    #import sys;sys.argv = ["", "Test.testName"]
    unittest.main()