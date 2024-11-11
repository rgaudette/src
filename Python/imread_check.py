import sys
print('Python: {}'.format(sys.version_info))
import numpy.version
print('Numpy: {}'.format(numpy.version.full_version))
import scipy.version
print('Scipy: {}'.format(scipy.version.full_version))
import matplotlib
print('Matplotlib: {}'.format(matplotlib.__version__))

try:
    from imageio import imread
    print('using imageio imread')
except ImportError:
    from scipy.misc import imread
    print('using scipy.misc imread')
