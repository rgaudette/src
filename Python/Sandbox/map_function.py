"""
Created on Nov 18, 2009

@author: Rick Gaudette
"""

class AClass:
    def __init__(self, a):
        self.a =a
        
    def func(self, inc):
        self.a = self.a + inc
        return self.a

list_of_obj = [AClass(1), AClass(2), AClass(3)]

# How to get a map to work with class methods
inc_values = map(AClass.func(2), list_of_obj)
print inc_values

print("Original")
for c in list_of_obj:
    print c.a

print("Incremented by 2")
for c in list_of_obj:
    c.func(2)
    print c.a

# List comprehension
list_comp = [x.func(2) for x in list_of_obj]
print("List comprehension")
for i in list_comp:
    print i
