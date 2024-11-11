from __future__ import division

import matplotlib.pyplot as plt
import numpy as np

n_elem = 10
z = np.arange(n_elem)
n_plots = 4
for index in range(n_plots):
    hax = plt.subplot(n_plots, 1, index+1)
    print n_plots-index-1, -n_plots+index
    sub_vec = z[n_plots-index-1:-n_plots+index]
    plt.scatter(sub_vec, sub_vec, 100, sub_vec, marker = 's', vmin = np.min(z), vmax = np.max(z))
    plt.xlim(np.min(z), np.max(z))
    plt.ylim(np.min(z), np.max(z))
plt.show()
