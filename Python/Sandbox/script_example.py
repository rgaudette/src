'''
Created on Apr 6, 2010

@author: rick
'''
import sys
#import myPackage.MyClass1

def before():
    print("Before")
    
if __name__ == '__main__':
    print sys.path
#    mc1 = myPackage.MyClass1.MyClass()
#    print mc1.a1
    before()
    after()
    
def after():
    print("After")