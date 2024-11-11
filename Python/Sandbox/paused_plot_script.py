'''
@author: rick
'''
from numpy import *
from pylab import *

def pps():
    a = arange(10)
    
    for i in range(2):
        figure(i+1)

        plot(a, a**i)
        draw()
    show()
    
if __name__ == "__main__":
    pps()
    print("done") 