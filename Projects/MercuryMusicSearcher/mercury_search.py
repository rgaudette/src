"""Describe the module
"""
from __future__ import division

import argparse
import collections
import os
import sys

description = __doc__
epilog = """
This text is presented below the arguments, it is a good place to list assumptions, requirements, side effects
or discussions of the program.  If this text here is already formatted see the argparse.RawDescriptionHelpFormatter in
http://docs.python.org/library/argparse.html#formatter-class
"""

"""
:author: Rick Gaudette
:date: 2014-06-03 
"""


def parse_command_line():
    arg_parser = argparse.ArgumentParser(description = description, epilog = epilog,
                                         formatter_class = argparse.ArgumentDefaultsHelpFormatter)

    arg_group = arg_parser.add_mutually_exclusive_group(required = True)
    arg_group.add_argument("-1", "--g1", help = "Group select 1")
    arg_group.add_argument("-2", "--g2", help = "Group select 2")

    arg_parser.add_argument("-o", "--option", help = "An option")
    arg_parser.add_argument("-i", "--integer", type = int, help = "An options")

    arg_parser.add_argument("pos_arg_first")
    arg_parser.add_argument("pos_arg_second")

    args = arg_parser.parse_args()

    print args.g1
    print args.g2
    print args.option
    print args.integer
    print("First positional argument: " + args.pos_arg_first)
    print("Second positional argument: " + args.pos_arg_second)

    return args


def main():
    args = parse_command_line()


if __name__ == "__main__":
    main()
