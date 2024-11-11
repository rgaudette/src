from __future__ import division

"""
:author: Rick Gaudette
:date: 2011-08-21 
"""

import unittest

import sacsys.geometry as ssgeom

class PointDict(dict):

#    def __init__(self):
#        self.data = dict()
#
#    def __getitem__(self, item):
#        return self.data[item]
#
#    def __setitem__(self, key, value):
#        self.data[key] = value

    def z_max(self):
        return reduce(lambda x, y : x.z if y.z < x.z else y.z, self.itervalues())

    
class PointDictTestCase(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        pass


    def test_set_get(self):
        point_dict = PointDict()
        p_0 = ssgeom.point(1, 2, 3)
        point_dict['p_0'] = p_0
        self.assertEquals(point_dict['p_0'], p_0)


    def test_z_max(self):
        point_dict = PointDict()
        p_0 = ssgeom.point(1, 2, 3)
        p_1 = ssgeom.point(1, 2, 7)
        point_dict['p_0'] = p_0
        point_dict['p_1'] = p_1
        print point_dict.z_max()
        
    @classmethod
    def tearDownClass(self):
        pass

