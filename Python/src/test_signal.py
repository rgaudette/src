"""
Created on Jul 1, 2010

@author: rick
"""

import unittest
import test_circshift
import test_xcorr_fd
import test_lenxcorr

test_loader = unittest.TestLoader()
test_loader.sortTestMethodsUsing = None
suite = unittest.TestSuite()

# Add the test cases for this suite below
suite.addTests(test_loader.loadTestsFromTestCase(test_circshift.TestCircshift))
suite.addTests(test_loader.loadTestsFromTestCase(test_xcorr_fd.TestXcorrFD))
suite.addTests(test_loader.loadTestsFromTestCase(test_lenxcorr.TestLenxcorr))
unittest.TextTestRunner(verbosity = 2).run(suite)    
