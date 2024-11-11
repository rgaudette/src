from __future__ import division

import numpy as np
import matplotlib.pyplot as plt
x = np.arange(-6, 6, 0.01)
one_plus_ex = 1 + np.exp(x)
p_x = 1 / one_plus_ex

dp_dx = p_x * (1 - p_x)

plt.plot(x, p_x / max(p_x))
plt.plot(x, dp_dx / max(dp_dx))
plt.grid(True)
plt.yticks([0.25, 0.5, 0.75])
plt.show()