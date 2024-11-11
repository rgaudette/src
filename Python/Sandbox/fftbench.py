import time
from numpy import *
from numpy.random import *
from numpy.fft.fftpack import *

def fftbench(data_size = 192, iterations = 10):
    x = standard_normal((data_size, data_size, data_size));
#    iterations = 10

    st = time.time()

    for n in range(iterations):
        X = fftn(x)

    dt = time.time()
    elapsed_time  = dt - st

    print('%d 3D FFT %d Interations elapsed time: %f\n' %(data_size, iterations, elapsed_time) )
    return elapsed_time
