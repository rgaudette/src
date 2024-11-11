"""Describe the module
"""

"""
:author: Rick Gaudette
:date: 2019-11-14 
"""

import argparse
import collections
import os
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

def sink(arg):
    pass

class ExampleTestCase(unittest.TestCase):
    def __init__(self, methodName='runTest'):
        super(ExampleTestCase, self).__init__(methodName)
        #self.writer = sys.stderr.write
        self.writer = sink

    @classmethod
    def setUpClass(cls):
        self = cls()
        self.writer("setUpClass: setup function that get run once before any tests\n")

    @classmethod
    def tearDownClass(cls):
        self = cls()
        self.writer("tearDownClass: this get run once, after all tests in the class have run\n")

    def setUp(self):
        self.writer("setUp: this get run before each test function\n")

    def test_01_second_test(self):
        self.writer("test_01_second_test\n")
        self.assertNotEqual(True, True, msg="this test should fail, and assertNotEqual should not write == !")

    def test_00_first_test(self):
        self.writer("test_00_first_test\n")
        self.assertEqual(True, True)

    def test_02_third_test(self):
        self.writer("test_02_third_test\n")
        self.assertEqual(True, True)

    def test_03_subtest(self):
        self.writer("test_03_subtest\n")


    def tearDown(self):
        self.writer("tearDown: this gets run after test function\n")
