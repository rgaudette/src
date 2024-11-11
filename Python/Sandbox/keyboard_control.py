description = """
A short description of the program.
"""
epilog = """
This text is presented below the arguments, it is a good place to list assumptions, requirements, side effects 
or discussions of the program.  If this text here is already formatted see the argparse.RawDescriptionHelpFormatter in 
http://docs.python.org/library/argparse.html#formatter-class
"""

"""
:author: Rick Gaudette
:date: Dec 7, 2010
"""

import argparse
import sys

import numpy as np
import matplotlib.pyplot as plt

def onpress(event):
    print event
    print dir(event)
    print event.canvas
    print event.guiEvent
    print event.inaxes
    print event.key
    print event.lastevent
    print event.name
    print event.x
    print event.xdata
    print event.y
    print event.ydata
    
    print('button=%s, xdata=%f, ydata=%f' % (event.key))
    if event.key == "q":
        sys.exit()
        
def mouse_handle():
    fig = plt.figure(1)
    fig.canvas.mpl_connect('key_press_event', onpress)
    a = np.arange(10)

    i = 1
    while True:
        plt.plot(a, a**i)
        plt.draw()
        i = i + 1
        plt.waitforbuttonpress()
    plt.show()
    
if __name__ == "__main__":
    
    mouse_handle()
    print("done")
    