from __future__ import division
from numpy import *
from matplotlib.pyplot import *

def main():
    data = zeros((5,5))
    data[0:2, 3:5] = 1
    data[4, 0] = 2

    figure(1)
    # imshow draws a pixel centered on the data index
    imshow(data, interpolation='nearest') # defaults to rc image.interpolation value, probably bilinear
    xlabel('column index')
    ylabel('row index')
    title('imshow')
    grid(True)
    colorbar()

    figure(2)
    # pcolor draw each pixel starting at the data index
    # By default pcolors increase the yaxis (row index) in the upward direction
    pcolor(data)
    xlabel('column index')
    ylabel('row index')
    title('pcolor')
    grid(True)
    colorbar()

    figure(3)
    # Inverting the yaxis shows the data similar to imshow
    pcolor(data)
    gca().invert_yaxis()
    xlabel('column index')
    ylabel('row index')
    title('pcolor inverted Y-axis')
    grid(True)
    colorbar()

    show()


if __name__ == '__main__':
    main()