'''
Created on Aug 27, 2010

@author: rick
'''
import warnings
import unittest
import numpy as np
warnings.simplefilter("error", Warning)

def test_warning(arg1):
    a = np.log(0)
    #warnings.warn("A simple warning", Warning)
    
    
class Test(unittest.TestCase):


    def testName(self):
        test_warning(1)


if __name__ == "__main__":
    test_warning(1)