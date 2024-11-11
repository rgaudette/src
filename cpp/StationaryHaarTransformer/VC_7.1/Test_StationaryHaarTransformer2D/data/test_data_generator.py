""" Generate the input and output test data for the StationaryWaveletTransform.cpp class
"""
from __future__ import division
import numpy as np
import pywt
import scipy.misc as spmisc

import sacsys.stationary_wavelet_transform as ssswt
import wavelet_denoise

def write_vector(vector, filename):
    with open(filename, "w") as outfile:
        for value in vector:
            outfile.write("{}\n".format(value))


def write_array(array, filename):
    with open(filename, "w") as outfile:
        [n_rows, n_columns] = array.shape
        outfile.write("{:d} {:d}\n".format(n_rows, n_columns))
        for i_row in range(n_rows):
            for i_column in range(n_columns):
                outfile.write("{} ".format(array[i_row, i_column]))
            outfile.write("\n")


def write_coefficients(wavelet, name, signal):
    n_levels = 3
    print("3 Level SWT")
    print("##################################################################")

    swt = pywt.swt(signal, unit_haar, n_levels)
    for idx_level in range(n_levels - 1, -1, -1):
        level = n_levels - idx_level
        filename = "{} {} {} approximation l{}.txt".format(wavelet.name, name, len(signal), level)
        print("Writing: {}".format(filename))
        write_vector(swt[idx_level][0], filename)
        filename = "{} {} {} detail l{}.txt".format(wavelet.name, name, len(signal), level)
        print("Writing: {}".format(filename))
        write_vector(swt[idx_level][1], filename)


def write_2D_swt(basename, coeffs):
    for i_level, level in enumerate(coeffs):
        filename = "{}_L{}_LL.dat".format(basename, i_level)
        write_array(level[0], filename)
        filename = "{}_L{}_HL.dat".format(basename, i_level)
        write_array(level[1][0], filename)
        filename = "{}_L{}_LH.dat".format(basename, i_level)
        write_array(level[1][1], filename)
        filename = "{}_L{}_HH.dat".format(basename, i_level)
        write_array(level[1][2], filename)


def zero_skipped_ratio(numer, denom):
    eps = np.finfo(np.float32).eps
    accum  = list()

    for numer_row, denom_row in zip(numer, denom):
        for numer_elem, denom_elem in zip(numer_row, denom_row):
            if denom_elem > eps:
                accum.append(numer_elem / denom_elem)

    return accum


def verify_unit_haar_scaling(standard, unit):
    for i_level, (std_sub, unit_sub) in enumerate(zip(standard, unit)):
        print("Level: {}".format(i_level))

        subband_ratio = zero_skipped_ratio(unit_sub[0], std_sub[0])
        m = np.mean(subband_ratio)
        s = np.std(subband_ratio)
        print("LL subband (unit:std) ratio: {:0.2f}({:0.2f})".format(m, s))

        subband_ratio = zero_skipped_ratio(unit_sub[1][0], std_sub[1][0])
        m = np.mean(subband_ratio)
        s = np.std(subband_ratio)
        print("LH subband (unit:std) ratio: {:0.2f}({:0.2f})".format(m, s))

        subband_ratio = zero_skipped_ratio(unit_sub[1][1], std_sub[1][1])
        m = np.mean(subband_ratio)
        s = np.std(subband_ratio)
        print("HL subband (unit:std) ratio: {:0.2f}({:0.2f})".format(m, s))

        subband_ratio = zero_skipped_ratio(unit_sub[1][2], std_sub[1][2])
        m = np.mean(subband_ratio)
        s = np.std(subband_ratio)
        # print("HH subband (unit:std) ratio: {:0.2f}({:0.2f})".format(m, s))



# The Haar specified in pywt is sqrt(2)^-1 [1, 1] & sqrt(2)^-1 [-1, 1]
haar = pywt.Wavelet('haar')
print haar.dec_lo
print haar.dec_hi
print haar.rec_lo
print haar.rec_hi

scale = np.array(np.sqrt(2))
scale_inverse = np.array(1 / scale)
# unit_haar = pywt.Wavelet('unit haar', [scale * haar.dec_lo,
#                                        scale * haar.dec_hi,
#                                        scale_inverse * haar.rec_lo,
#                                        scale_inverse * haar.rec_hi])

unit_haar = pywt.Wavelet('unit haar', [[1.0, 1.0], [-1.0, 1.0], [0.5, 0.5], [0.5, -0.5]])

print scale * haar.dec_lo
print scale * haar.dec_hi
print scale_inverse * haar.rec_lo
print scale_inverse * haar.rec_hi

# A simple 1D ramp to validate basic calculation and boundary conditions
name = "ramp"
ramp = np.arange(0.0, 16.0, dtype=np.float32)
filename = "{} {}.txt".format(name, len(ramp))
write_vector(ramp, filename)
write_coefficients(unit_haar, name, ramp)

name = "step"
step = np.array(np.concatenate((np.zeros(8), np.ones(8))), dtype=np.float32)
filename = "{} {}.txt".format(name, len(step))
write_vector(step, filename)
write_coefficients(unit_haar, name, step)

name = "random"
random = np.random.randn(1024)
filename = "{} {}.txt".format(name, len(random))
write_vector(random, filename)
write_coefficients(unit_haar, name, random)

# print("1 Level SWT")
# print("##################################################################")
# swt = pywt.swt(test, unit_haar, 1)

# approximation_1 = swt[0][0]
# write_vector(approximation_1, "swt_ramp_16_approximation_l1.txt")
#
# detail_1 = swt[0][1]
# write_vector(detail_1, "swt_ramp_16_detail_l1.txt")

# Reconstruction
# recon = ssswt.swtrec(swt, unit_haar)
# print recon

im_byte = spmisc.imread("bga_512x512.png")
print im_byte.dtype
print im_byte[0, 0]
print np.min(im_byte), np.max(im_byte)
im_float = np.asarray(im_byte, np.float32)
print im_float.dtype
print im_float[0, 0]
print np.min(im_float), np.max(im_float)


n_levels = 5
wavelet = pywt.Wavelet('haar')
stationary_haar = pywt.swt2(im_float, wavelet, n_levels)
# write_2D_swt("bga_512x512_haar", stationary_haar)

stationary_unit_haar = pywt.swt2(im_float, unit_haar, n_levels)
write_2D_swt("bga_512x512_unit_haar", stationary_unit_haar)
verify_unit_haar_scaling(stationary_haar, stationary_unit_haar)

# approx_scale_factor = 0.5 ** (i_level + 1) * pixel_gain
# spatial_std_est = np.sqrt(cA * approx_scale_factor)
# threshold = spatial_std_est * global_weight * subband_threshold_weights[i_level]
pixel_gain = 0.35
subband_threshold_weights = np.ones(len(stationary_unit_haar))
diagonal_subband_weight = np.ones(len(stationary_unit_haar))
hard = False
global_weight = 1.0
shrunk_stationary_unit_haar = wavelet_denoise.approx_weighted_threshold(stationary_unit_haar, pixel_gain, subband_threshold_weights, diagonal_subband_weight, hard, global_weight)

write_2D_swt("bga_512x512_shrunk_unit_haar", stationary_unit_haar)
