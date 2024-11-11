"""
Created on Feb 22, 2011

@author: rick
"""

import numpy as np
import matplotlib.pyplot as plt

import  scipy.cluster.vq

observations = np.array([2, 1, 3, 3, 1, 2, 1, 3, 2, 1, 2, 2, 3, 1, 1, 2])
clusters = np.array([0, 1.9, 4])
centroids = scipy.cluster.vq.kmeans(observations, 4)
print centroids
