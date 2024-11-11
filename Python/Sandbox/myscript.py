#!/usr/bin/python
"""
Created on Dec 22, 2009

@author: Rick Gaudette
"""
print("This is a global statement")

def func():
    print("This is a function statement")

print("__name__ is defined as {0}".format(__name__))    

if __name__ == '__main__':
    print("Executing __main__")
    func()

