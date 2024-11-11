'''
The purpose of the this module is to explore the best way to work many objects of the same structure.  I can think of
two ways in which to structure information like this.  First, we can have an object that represents a single instance
of the type we are interested, then use a container the manage many of these objects.  I have named this approach 
Container of Objects. The second approach is to use a container for each attribute within the object   
'''
import numpy as np
import unittest

# Container of compound object (CCO) pattern
class CompoundObject(object):
    def __init__(self, name = None, attribute_1 = None, val_1 = None, val_2 = None):
        self.name = name
        self.attribute_1 = attribute_1
        self.val_1 = val_1
        self.val_2 = val_2



# Compound object of containers (COC) pattern 
class CompundObjectOfContainers(object):
    def __init__(self, name = None, attribute_1 = None, val_1 = None, val_2 = None):
        self.name = name
        self.attribute_1 = attribute_1
        self.val_1 = val_1
        self.val_2 = val_2
        
class Test_patterns(unittest.TestCase):


    def test_CCO(self):
        # Create a CCO
        cco = list()
        co = CompoundObject(name = "co_1", attribute_1 = "attr_1", val_1 = 1, val_2 = 2)
        cco.append(co)
        co = CompoundObject(name = "co_2", attribute_1 = "attr_2", val_1 = -1, val_2 = 4)
        cco.append(co)


        # Extract out specific compound object
        
        # Find an object with a specific value
        
        # Add an object to the collection
        
        # Remove an object from the collection
         
if __name__ == "__main__":
    unittest.main()