"""Describe the module
"""

import argparse
import collections
import os
import sys

class AClass:
    def __init__(self, a1, a2, a3):
        self.a1 = a1
        self.a2 = a2
        self.a3 = a3

class AnotherClass:
    attrib: int = 5

    def __init__(self):
        print(self.attrib)
        self.attrib = 6

class EasyInit(object):
    def __init__(self, attr1, attr2):
        # Initialize the class by creating attributes with the names of arguments
        # the disadvantage is that IDEs don't know how to parse this
        # and from the Python Cookbook 2ed
        # "it does not play well with properties and other advanced descriptors"
        self.__dict__.update(locals())
        del self.self



def main():
    a_class_1 = AClass(1,2,3)
    a_class_2 = AClass(*(1,2,3))
    print(a_class_1)
    print(a_class_2)

    ei = EasyInit(10, 20)

    print(ei.attr1)
    print(ei.attr2)

    another_class = AnotherClass()
    print(another_class.attrib)

if __name__ == "__main__":
    main()
