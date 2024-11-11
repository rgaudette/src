import unittest

def include(pathname, scope_dict):
    """
    Evaluate the specified file in the context supplied
    """

class IncludeTest(unittest.TestCase):
    """
    """
    # @classmethod
    # def setUpClass(cls):
    #     cls.test_root = None
    #     try:
    #         cls.test_root = os.path.join(os.environ['IRPTOOLS_TEST_DATA_DIR'])
    #     except KeyError as exception:
    #         print(exception.message)


    def test_0_verify_test_root(self):
        self.assertIsNotNone(self.test_root, "Environment variable IRPTOOLS_TEST_DATA_DIR is not defined")