from __future__ import division

"""
:author: Rick Gaudette
:date: 2011-10-03 
"""

one_space = "a b"
tokens = one_space.split(" ")
print tokens

two_spaces = "a  b"
tokens = two_spaces.split(" ")
print tokens
num_with_lf = """1.234A"""
nlf = float(num_with_lf)
print nlf