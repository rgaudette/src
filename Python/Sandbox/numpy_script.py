'''
Created on Sep 17, 2009

@author: rick
'''
import sys
import os
import numpy.core
import matplotlib.pyplot

print("This is a simple script")
print("The arguments to the script were:")
print(sys.argv)
print("The current directory is %s" %  os.getcwd())
numpy_vector = numpy.core.array([1,2,3,4])
print(numpy_vector)

matplotlib.pyplot.plot(numpy_vector)
matplotlib.pyplot.show()
numpy_matrix = numpy.core.array([[1,3,4],[3,2,1]])
print(numpy_matrix)
print('Done')