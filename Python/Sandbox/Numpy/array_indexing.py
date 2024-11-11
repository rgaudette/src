"""
Created on Jan 3, 2010

@author: Rick Gaudette
"""
import numpy as np

ramp = np.arange(1,11)
print(ramp)
idx = ramp > 3
print(idx)
sel_ramp = ramp[idx]
print(sel_ramp)

# sequentially assigning values to an array (useful if the expression is complex)
# doesn't work
e = np.empty(10)
i = 0
for e_ref in e:
    e_ref = i
    i += 1
    

print e

#=======================================================================================================================
# Iteration 2D Arrays  
#=======================================================================================================================

two_d = np.arange(0,12).reshape(3, 4)
two_d_neg = -1 * two_d

# Row iterator read
print("Iterator read")
for row in two_d:
    print row

# Row iterator enumerate and read
print("Iterator read")
for i, row in enumerate(two_d):
    print i
    print row

# ND enumerate and read
print("ndenumerate iterator read")
for idx, val in np.ndenumerate(two_d):
    print idx, val
    print two_d_neg[idx]
    
# Iterator Assignment
# - the row object returned is a ndarray that references the selected row.  To copy data into that row we use the 
# [] operator on the left side (equivalent to __setslice__)
print("Iterator assignment")
for row in two_d:
    row[:] = [1, 2, 3, 4]
print two_d


two_d_it = iter(two_d)
print two_d_it
first = two_d_it.next()
print first    

# Extracting a region and iterating over it
print("Extracting a region and iterating over it")
two_d = np.arange(0,12).reshape(3, 4)
sub_row = slice(1, 3)
sub_col = slice(2, 4)

for idx, val in np.ndenumerate(two_d[sub_row, sub_col]):
    print idx, val

#=======================================================================================================================
# N dimensional arrays
#=======================================================================================================================
print("N dimensional arrays")
s = np.arange(5*4*3)
# reshape does not change the shape of s, but rather returns a new view of the array using the specified shape

sr = s.reshape(5,4,3)
sr[0,0,0] = 100
print sr
print s

