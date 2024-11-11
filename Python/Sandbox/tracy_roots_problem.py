from scipy import interpolate
import matplotlib.pyplot as plt
from numpy import *
import pickle

F = open('datafile.txt','rb')
[xdata, ydata, y] = pickle.load(F)
print xdata
print ydata
print y

yreduced = ydata - y
#plt.plot(xdata, yreduced)
#plt.grid(True)
#plt.show()
s = 1E-3
print("s = {}".format(s))
freduced = interpolate.UnivariateSpline(xdata, yreduced, k=3,s = s) # s=None or float

est_x = freduced.roots()
print("len(est_x): {} ".format(len(est_x)))#I get zero roots.
print("est_x: {}".format(est_x))
