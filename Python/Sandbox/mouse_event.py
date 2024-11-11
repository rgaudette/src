'''
This does not work from with Eclipse, nor from the command line.  IPython must have the backend setup correctly to handle the UI.

@author: rick
'''
import numpy as np
import matplotlib.pyplot as plt

#plt.ion()
fig = plt.figure()
ax = fig.add_subplot(111)
ax.plot(np.random.rand(10))
plt.draw()
raw_input("Enter to quit:")

def onclick(event):
    print('button={}, x={}, y={}, xdata={}, ydata={}'.format(event.button, event.x, event.y, event.xdata, event.ydata))
    if event.button == 1:
        print("Replotting")
        plt.plot(np.random.rand(10))
    else:
        print("Clearing")
        fig = plt.gcf()

        fig.canvas.mpl_disconnect(cid)
        plt.clf()
               
    

cid = fig.canvas.mpl_connect('button_press_event', onclick)

#fig.canvas.mpl_disconnect(cid)
