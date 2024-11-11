import sys
import unittest

class SimpleTestCase(unittest.TestCase):


    def setUp(self):
        sys.stderr.write("setUp\n")

    def test_01_second_test(self):
        sys.stderr.write("test_01_second_test\n")
        self.assertEqual(True, True)

    def test_00_first_test(self):
        sys.stderr.write("test_00_first_test\n")
        self.assertEqual(True, True)

    def tearDown(self):
        sys.stderr.write("tearDown\n")

if __name__ == '__main__':
    unittest.main()
