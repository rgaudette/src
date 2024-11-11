"""Describe the module
"""

"""
:author: Rick Gaudette
:date: 2019-11-14 
"""

import sys
import unittest

import matplotlib.pyplot as plt
import numpy as np
import scipy as sp
import scipy.linalg as spla
import scipy.misc as spmisc
import scipy.signal as spsig
import scipy.special as spspec
import scipy.ndimage as spndi
import numpy.testing as npt


class ExampleTestCase(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        sys.stderr.write("setUpClass: this get run once\n")

    def setUp(self):
        sys.stderr.write("setUp: this get run before each method\n")

    def test_01_second_test(self):
        sys.stderr.write("test_01_second_test\n")
        self.assertEqual(True, True)

    def test_00_first_test(self):
        sys.stderr.write("test_00_first_test\n")
        self.assertEqual(True, True)

    def tearDown(self):
        sys.stderr.write("tearDown: this get run after each method\n")

    @classmethod
    def tearDownClass(self):
        sys.stderr.write("tearDownClass: this get run once at the end\n")