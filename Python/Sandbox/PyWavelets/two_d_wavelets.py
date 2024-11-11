from __future__ import division


from numpy import *
from pywt import *
from matplotlib.pyplot import *

set_printoptions(precision=3, linewidth=160)
def main():


    pulse = zeros((32, 32))
    pulse[7:15, 7:15] = 1.0
    fig_id = 1

    figure(fig_id)
    imshow(pulse, interpolation='nearest')
    grid(True)
    fig_id += 1

    decomp = wavedec2(pulse, 'haar', level = 3)
    figure(fig_id)
    imshow(decomp[0], interpolation='nearest')
    fig_id += 1

    for level, coeffs in enumerate(decomp[1:]):

        figure(fig_id)
        suptitle("Level {}".format(len(decomp) - 1 - level))
        # pywt author calls this the vertical coefficients but it seems like the horizontal to me
        subplot(2,2,2)
        imshow(coeffs[1], interpolation='nearest')
        title('Vertical detail')

        # pywt author calls this the vertical coefficients but it seems like the horizontal to me
        subplot(2,2,3)
        imshow(coeffs[0], interpolation='nearest')
        title('Horizontal detail')

        subplot(2,2,4)
        imshow(coeffs[2], interpolation='nearest')
        title('Diagonal detail')
        fig_id += 1

    show()



if __name__ == "__main__":
    main()
