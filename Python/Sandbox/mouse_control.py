'''
Created on Sep 22, 2009

@author: rick
'''
import sys
from numpy import *
from pylab import *

def on_click(event):
    print dir(event)
    print('button: {}'.format(event.button))
    print('canvas: {}'.format(event.canvas))
    print('guiEvent: {}'.format(event.guiEvent))
    print('inaxes: {}'.format(event.inaxes))
    print('lastevent: {}'.format(event.lastevent))
    print('name: {}'.format(event.name))
    print('step: {}'.format(event.step))
    print('x: {}'.format(event.x))
    print('y: {}'.format(event.y))
    print('xdata: {}'.format(event.xdata))
    print('ydata: {}'.format(event.ydata))


def on_key(event):
    print dir(event)
    print('key: {}'.format(event.key))
    print('canvas: {}'.format(event.canvas))
    print('guiEvent: {}'.format(event.guiEvent))
    print('inaxes: {}'.format(event.inaxes))
    print('lastevent: {}'.format(event.lastevent))
    print('name: {}'.format(event.name))
    print('x: {}'.format(event.x))
    print('y: {}'.format(event.y))
    print('xdata: {}'.format(event.xdata))
    print('ydata: {}'.format(event.ydata))

    if event.key == 'q':
        sys.exit(0)

def mouse_handle():
    print dir()
    fig = figure(1)
    _ = fig.canvas.mpl_connect('button_press_event', on_click)
    _ = fig.canvas.mpl_connect('key_press_event', on_key)
    a = arange(10)
    plot(a, a**2)
    draw()
    while True:
        waitforbuttonpress()

if __name__ == "__main__":
    #my_class = MyClass()
    mouse_handle()

    print("done") 