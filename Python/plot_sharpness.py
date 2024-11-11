from numpy import *
from matplotlib.pyplot import *

def plot_sharpness(sharpness, *args):
    """
    Plot a sharpness profile on the current axis
    sharpness    Either a string specifying a filename or Nx2 array containing the z & sharpness values 
    *args        Line property arguments passed to setp()
    """

    if isinstance(sharpness, basestring):
        sharpness = loadtxt(sharpness)
        
    h_line = plot(sharpness[:,0], sharpness[:,1])

    setp(h_line, 'linewidth', 2.0)

    if len(args) > 0 :
        setp(h_line, *args)

    return sharpness
