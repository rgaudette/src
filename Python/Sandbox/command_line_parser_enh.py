"""Describe the module
"""
from __future__ import division

import argparse
import collections
import os
import sys

description = __doc__
epilog = """
"""
class EnhancedArgParser(argparse.ArgumentParser):
    def convert_arg_line_to_args(self, arg_line):
        if not arg_line[0] ==  "#":
            yield arg_line


argparser = EnhancedArgParser(description = description, epilog = epilog,
                              formatter_class = argparse.ArgumentDefaultsHelpFormatter, fromfile_prefix_chars = '@')

argparser.add_argument("-a", "--an_option")
argparser.add_argument("-b", "--an_other_option")
argparser.add_argument("pos_arg")

args = argparser.parse_args()

print(args.an_option)
print(args.an_other_option)
print(args.pos_arg)
