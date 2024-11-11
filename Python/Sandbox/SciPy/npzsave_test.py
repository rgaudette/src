"""Describe the module
"""
from numpy import *

import axi.utilities.geometry as axigeom

class SimpleClass(object):
    def __init__(self):
        self.i = 3
        self.f = 4.0


def main():
    nda = arange(12)
    print(type(nda))
    savez("ndarry.npz", nda=nda)
    nda_dict = load("ndarry.npz")
    nda_in = nda_dict['nda']
    print(nda)
    print(nda_in)
    print(type(nda_in))
    print(type(nda_in[0]))

    print(dir(nda_dict))
    print (nda_dict._files)

    # A list of native types gets saved as an ndarray of those types
    l = list([1, 2, 3, 4.0])
    savez("list.npz", l=l)
    l_dict = load("list.npz")
    l_in = l_dict['l']
    print(l)
    print(l_in)
    print(type(l_in))
    print(type(l_in[0]))

    # A list of user defined classes
    c1 = SimpleClass()
    c2 = SimpleClass()
    c2.i = 1
    c2.f = 2.0
    ludt = list()
    ludt.append(c1)
    ludt.append(c2)
    savez("ludt.npz", ludt=ludt)
    ludt_dict = load("ludt.npz");
    ludt_in = ludt_dict['ludt']
    print(ludt_in[0].i, ludt_in[0].f)
    print(ludt_in[1].i, ludt_in[1].f)

    # A list of axigeom.Point2D
    p1 = axigeom.Point2D(1.0, 2.0)
    p2 = axigeom.Point2D(3.0, 4.0)
    lp2d = list()
    lp2d.append(p1)
    lp2d.append(p2)
    savez("lp2d.npz", lp2d=lp2d)
    lp2d_dict = load("lp2d.npz");
    lp2d_in = lp2d_dict['lp2d']
    print(lp2d_in[0].x, lp2d_in[0].y)
    print(lp2d_in[1].x, lp2d_in[1].y)


    # A list of axigeom.Point2D_float
    p1 = axigeom.Point2D_float(1.0, 2.0)
    p2 = axigeom.Point2D_float(3.0, 4.0)
    lp2df = list()
    lp2df.append(p1)
    lp2df.append(p2)
    savez("lp2df.npz", lp2df=lp2df)
    lp2df_dict = load("lp2df.npz");
    lp2df_in = lp2df_dict['lp2df']
    print(lp2df_in[0].x, lp2df_in[0].y)
    print(lp2df_in[1].x, lp2df_in[1].y)

    # A list of axigeom.Rectangle_float
    r1 = axigeom.Rectangle_float(1.0, 2.0, 5.0, 6.0)
    r2 = axigeom.Rectangle_float(3.0, 4.0, 7.0, 8.0)
    lrf = list()
    lrf.append(r1)
    lrf.append(r2)
    savez("lrf.npz", lrf=lrf)
    lrf_dict = load("lrf.npz")
    lrf_in = lrf_dict['lrf']
    print(lrf_in[0].origin.x, lrf_in[0].origin.y, lrf_in[0].width, lrf_in[0].length)
    print(lrf_in[1].origin.x, lrf_in[1].origin.y, lrf_in[1].width, lrf_in[1].length)

    # list of ndarrays

if __name__ == "__main__":
    main()
