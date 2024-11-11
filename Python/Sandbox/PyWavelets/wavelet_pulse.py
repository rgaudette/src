from __future__ import division

from numpy import *
from pywt import *

set_printoptions(precision=3, linewidth=160)

def main():
    n_samples = 8
    pulse = zeros(n_samples)

    # Whether the pulse starts and ends on a odd or even has a significant effect on the detail coefficients for this
    # example
    #pulse[2:4] = 1.0
    pulse[3:5] = 1.0

    print "Pulse"
    print pulse
    print ""

    haar = Wavelet('haar')

    app_conv = convolve(haar.dec_lo, pulse)
    det_conv = convolve(haar.dec_hi, pulse)
    print "My coeffs"
    print app_conv
    print det_conv
    print ""

    cA, cD = dwt(pulse, 'haar')
    print "DWT"
    print cA
    print cD
    print ""

    coeffs = wavedec(pulse, 'haar', level = 1)
    print "Wavedec"
    print coeffs[0]
    print coeffs[1]
    print

    rec_idwt = idwt(cA, cD, 'haar')
    print "Rec IDWT"
    print rec_idwt
    print

    rec_wave = waverec(coeffs, 'haar')
    print "Rec waverec"
    print rec_wave
    print

if __name__ == "__main__":
        main()