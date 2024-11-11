from numpy import loadtxt

import os

class GaussianModel:
    """
    
    """

    def load(self, filename):
        vec = loadtxt(filename)
        mean = vec[0]
        sigma = vec[1]
        amplitude = vec[2]
        left_background = vec[3]
        right_background = vec[4]

#    def evaluate(self):

import unittest
class  GaussianModelTestCase(unittest.TestCase):
    #def setUp(self):
    #    self.foo = GaussianModel()
    #

    #def tearDown(self):
    #    self.foo.dispose()
    #    self.foo = None

    def test_gaussianModel_load(self):
        print(os.getcwd())
        
        gaussian_model = GaussianModel()
        gaussian_model.load("gaussian_lmfit_R01355_F13818_L2.txt")
        expected_mean = -856606
        self.assertEqual(-856606, gaussian_model.mean,
            "Gaussian model mean not loaded correctly, expected %d, got %d" % (expected_mean, gaussian_model.mean))

if __name__ == '__main__':
    unittest.main()

