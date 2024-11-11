"""Describe the module
"""
from __future__ import division

import re

"""
:author: Rick Gaudette
:date: 2014-07-15 
"""


def main():
    reg_exp = re.compile('abc')
    match = reg_exp.search('abcdef')
    print match


if __name__ == "__main__":
    main()
