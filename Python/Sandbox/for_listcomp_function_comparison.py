"""
Created on Dec 23, 2010

@author: Rick Gaudette
"""

# Speed comparison
import time
import random

#=======================================================================================================================
# Build the input objects
#=======================================================================================================================
n_elem = 2 * 1000 * 1000
seq = range(0, n_elem)

class Simple(object):
    def __init__(self):
        self.a = random.randrange(0,10)
        
seq_simple = [ Simple() for e in seq ]

#=======================================================================================================================
# Extracting out the odd number from the sequence 
#=======================================================================================================================
def mod_2(x):
    return x % 2
st = time.clock()
odd_filter = filter(mod_2, seq)
print("Filter list build: {0}".format(time.clock() - st))

st = time.clock()
odd_lc = [ elem for elem in seq if elem % 2]
print("List comprehension list build: {0}".format(time.clock() - st))        


odd_for = list()
st = time.clock()
for elem in seq:
    if elem % 2:
        odd_for.append(elem)
print("For loop list build: {0}".format(time.clock() - st))        

#for a,b in zip(odd_filter, odd_lc):
#    if a != b:
#        print("Not equal")
#        break


st = time.clock()
a_lc = [ simple.a for simple in seq_simple ]
print("List comprehension attribute extract: {0}".format(time.clock() - st))        

st = time.clock()
a_for = list()
for simple in seq_simple:
    a_for.append(simple.a)
print("For loop attribute extract: {0}".format(time.clock() - st))        

def get_a(x):
    return x.a

st = time.clock()
a_filter = filter(get_a, seq_simple)
print("Filter attribute extract: {0}".format(time.clock() - st))

print("Done")
