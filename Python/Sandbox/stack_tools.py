'''
Created on Feb 9, 2010

@author: rick
'''
import traceback

def show_depth():
    st = traceback.extract_stack()
    print len(st)

def level2():
    show_depth()    

def level1():
    show_depth()
    level2()

show_depth()
level1()
show_depth()
