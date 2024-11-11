'''
Created on Feb 28, 2010

@author: rick
'''

class class_with_properties(object):
    
    def __init__(self):
        self.the_attr = 10
        self.__private = -10
    @property
    def attr(self):
        return self.the_attr
    
    @attr.setter
    def attr(self, value):
        self.the_attr = value
        
    @property
    def private(self):
        return self.__private
    
    @private.setter
    def private(self, value):
        self.__private = value
        
c = class_with_properties()

print(c.attr)
print(c.the_attr)
c.attr = 5
print(c.attr)
print(c.the_attr)

print(c.private)
# print(c.__private) raises an AttributeError 
c.private = -5
print(c.private)
