from __future__ import division

from numpy import *
from pywt import *
from matplotlib.pyplot import *

set_printoptions(precision=3, linewidth=160)
def main():

    # 1D
    n_samples = 64
    pulse = zeros(n_samples)
    #pulse[2:4] = 1.0
    pulse[23:40] = 1.0

    fig_id = 1
    figure(fig_id)
    plot(pulse)
    fig_id += 1


    stationary_wt = swt(pulse, 'haar')

    n_levels = len(stationary_wt)
    n_seq = 2 * n_levels

    figure(fig_id)
    for i, (cA, cD) in enumerate(stationary_wt):
        subplot(n_seq, 1, 2 * i + 1)
        plot(cA)
        title("Approximation Level: {}".format(n_levels - i))

        subplot(n_seq, 1, 2 * i + 2)
        plot(cD)
        title("Detail Level: {}".format(n_levels - i))
    fig_id += 1

    # 2D
    pulse = zeros((32, 32))
    pulse[8:16, 8:16] = 1.0

    figure(fig_id)
    imshow(pulse, interpolation='nearest')
    grid(True)
    fig_id += 1

    # NOTE: the swt2 returns coefficients in the reverse level order compared to the other multilevel decomposition
    # algorithms in this package
    decomp = swt2(pulse, 'haar', 3)
    for level, coeffs in enumerate(decomp):
        figure(fig_id)
        suptitle("Level {}".format(level + 1))
        subplot(2,2,1)
        imshow(coeffs[0], interpolation='nearest')
        title('Approximation')
        subplot(2,2,2)
        imshow(coeffs[1][1], interpolation='nearest')
        title('Vertical detail')
        subplot(2,2,3)
        imshow(coeffs[1][0], interpolation='nearest')
        title('Horizontal detail')
        subplot(2,2,4)
        imshow(coeffs[1][2], interpolation='nearest')
        title('Diagonal detail')
        fig_id += 1

    show()



if __name__ == "__main__":
    main()
