'''
Created on Jun 30, 2010

@author: rick
'''
import os
import unittest
import numpy as np
import scipy.signal as sig
import matplotlib.pyplot as plt

import warnings
warnings.filterwarnings("ignore")

def im_corr(im1, im2):
    c = sig.correlate(im1, im2, mode = "valid")
    return c

def arg_max_nd(nd):
    flat_idx = nd.argmax()
    return np.unravel_index(flat_idx, nd.shape)

class Test(unittest.TestCase):


    def testName(self):
        max_shift = 20
        
        print("")
        print(os.getcwd())
        # Load each image
        im_filename = "bottom_1014_5287_346_188_4.png"
        #im_path_1 = os.path.join("..", "data", "Run_01", im_filename)
        im_path_1 = os.path.join("data", "Run_01", im_filename)

        im_1 = plt.imread(im_path_1)
        im_1 = im_1[max_shift:-max_shift,max_shift:-max_shift]
        print im_1.shape

        im_path_2 = os.path.join("..", "data", "Run_02", im_filename)
        im_path_2 = os.path.join("data", "Run_02", im_filename)
        im_2 = plt.imread(im_path_2)
        #im_2 = im_2[max_shift:-max_shift,max_shift:-max_shift]
        print im_2.shape

        c = im_corr(im_1, im_2)
        print c.shape

        print arg_max_nd(c)
        
if __name__ == "__main__":
    #import sys;sys.argv = ['', 'Test.testName']
    unittest.main()