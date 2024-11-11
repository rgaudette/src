"""Describe the module

:author: Rick Gaudette
:date: 2019-11-30 
"""

import argparse
import collections
import os
import sys

import Sandbox.argparse_modules.primary as primary

def main():
        arg_parser = primary.create_arg_parser()
        # get the defaults from the argument parser
        args = arg_parser.parse_args(args=['-a', 'a_value', 'a positional argument'])
        print(args)
        print(args.flag)

if __name__ == "__main__":
    main()
