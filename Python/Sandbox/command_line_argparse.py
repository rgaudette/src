""" A simple argparse based argument parser. This is a simple script meant to display the capabilities of
the argparse library.
"""

# Use the docstring as the description
description = __doc__
epilog = """ """

import argparse
import sys

if __name__ == '__main__':
    argparser = argparse.ArgumentParser(description = description,
                                        epilog = epilog,
                                        fromfile_prefix_chars='@')

    print(dir(argparser))
    argparser.add_argument("-a", "--an_option")
    argparser.add_argument("-b", "--an_other_option")
#    argparser.add_argument("pos_arg")


    args, unparsed = argparser.parse_known_args()
    print(args)

#    print type(args)
#
#    print args
#    print dir(args)
#
    print(args.an_option)
    print(args.an_other_option)

    print(unparsed)

