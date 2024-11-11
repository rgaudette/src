from __future__ import division

"""
:author: Rick Gaudette
:date: 2011-08-21 
"""

# can lambda contain an if statement?
l = [1, 5, 2, 2, 9]
m = reduce(lambda x, y : y if x < y else x, l)
print m


# passing a function with preset parameters
def my_func(value, offset):
    return value + offset

offset = 2
m = map(lambda x)