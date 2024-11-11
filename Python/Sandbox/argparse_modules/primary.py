""" Exploring how to get the arguments object defined in one module into another.  This will be useful in getting the
the defaults defined in one commend to be used in another.

:author: Rick Gaudette
:date: 2019-11-30
"""
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


def create_arg_parser():
    arg_parser = argparse.ArgumentParser(description = description, epilog = epilog,
                                         formatter_class = argparse.ArgumentDefaultsHelpFormatter)

    arg_group_image = arg_parser.add_mutually_exclusive_group(required=True)
    arg_group_image.add_argument('-a', '--arg_a', help='A help')
    arg_group_image.add_argument('-b', '--arg_b', help='B help')

    arg_parser.add_argument('-s', '--string',
                            help='Default type is string')
    arg_parser.add_argument('-i', '--int',
                            type=int,
                            default=1,
                            help='Can specify type and default value')
    arg_parser.add_argument('-f', '--flag',
                            action='store_true',
                            help='Binary input with default false.')
    # See the argparse documentation for more possibilities with the command line structure

    arg_parser.add_argument("positional_argument")

    return arg_parser


def parse_command_line():
    arg_parser = create_arg_parser()
    args = arg_parser.parse_args()
    return args



def main():
    args = parse_command_line()


if __name__ == "__main__":
    main()
