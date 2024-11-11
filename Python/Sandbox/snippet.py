from __future__ import division

"""
:author: Rick Gaudette
:date: 2011 08 20 
"""

if __name__ == '__main__':

    fmt_str = \
"""Slice locations are not equal
Slice key: {}
Reference location (x, y): {:>+9.2f}, {:>+9.2f} (mm)
Test location (x,y):       {:>+9.2f}, {:>+9.2f} (mm)"""
    print(fmt_str.format("1234 5", 1234.45, 7591.34, -12311.54,  -3.6))