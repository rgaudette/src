from __future__ import division

"""
:author: Rick Gaudette
:date: 2012-04-03 
"""

import numpy as np
import matplotlib.pyplot as plt

x = np.arange(-5, 5, 0.1)
gamma = 1.0
beta = gamma
expf = 1.0 - np.exp(-gamma * x)
logisticf = 1.0 / (1 + np.exp(-beta * x))

plt.figure()
plt.plot(x, expf)
plt.plot(x, logisticf)
plt.grid(True)
plt.show()

