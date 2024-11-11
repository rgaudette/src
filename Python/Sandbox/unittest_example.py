""" This module contains examples of the uses of the python unittest module.

To run the tests simply running, as below,  the script will execute all of the non-disabled tests
> unittest_example.py

to achieve more control, or run tests in a module that does not call unittest.main upon startup use
> python -m unittest unittest_example
will run all of the non-disabled tests in this module
> python -m unittest unittest_example.ExampleTestCase
will run all of the non-disabled tests in ExampleTestCase, and execution of the form
> python -m unittest unittest_example.ExampleTestCase.test_01_second_test
will specific test cases.


"""
import sys
import unittest


def sink(arg):
    pass


class ExampleTestCase(unittest.TestCase):
    def __init__(self, methodName = 'runTest'):
        super(ExampleTestCase, self).__init__(methodName)
        self.writer = sys.stderr.write
        # comment out the following line to
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
        self.assertNotEqual(True, True, msg = "this test should fail, and assertNotEqual should not write == !")

    def test_00_first_test(self):
        self.writer("test_00_first_test\n")
        self.assertEqual(True, True)

    def test_02_third_test(self):
        self.writer("test_02_third_test\n")
        self.assertEqual(True, True)

    # Skipping tests:
    # A test can skipped by annotating it
    @unittest.skip("test_03_fourth_test, annotated with skip")
    def test_03_fourth_test(self):
        self.writer("test_03_fourth_test\n")
        self.assertEqual(True, False)

    # or conditionally skipped with code
    @unittest.skipUnless(sys.platform.startswith("win"), "requires Windows")
    def test_04_fifth_test(self):
        self.writer("test_04_fifth_test\n")
        self.assertEqual(True, False)

    # or skipped by a function call
    def test_05_sixth_test(self):
        if True:
            self.skipTest("skipped test via the skipTest() function")
        self.writer("test_05_sixth_test\n")
        self.assertEqual(True, False)

    def test_even(self):
        """
        Test that numbers between 0 and 5 are all even.
        """
        for i in range(0, 6):
            with self.subTest(i=i):
                self.assertEqual(i % 2, 0)
    def tearDown(self):
        self.writer("tearDown: this gets run after test function\n")

if __name__ == '__main__':
    unittest.main()
