from collections import OrderedDict
import numpy as np

s = 'A string'
i = 7
f = 3.0
l = [1.0, 'abc', 2]
d = {"key1": 'val1', "key2": 2}
od = OrderedDict()
od["k1"] = 2.0
od["k2"] = "str"

nda = np.array([7.2, np.pi])


class UserType:
    def __init__(self):
        self.attr_1 = 1
        self.attr_2 = 2


ut = UserType()
print(ut.attr_1)

ut_array = np.array([ut], dtype=UserType)

# print("type(s):", type(s))
# print("type(i):", type(i))
# print("type(f):", type(f))
# print("type(l):", type(l))
# print("type(d):", type(d))
# print("type(nda):", type(nda))
# print("type(ut):", type(ut))
# print("type(ut_array):", type(ut_array))

np.savez('archive.npz', allow_pickle=True,
         s = s,
         i = [i],
         f = [f],
         l = [l],
         d = [d],
         od = [od],
         nda = nda,
         ut = ut,
         ut_array=ut_array)

archive = np.load('archive.npz', allow_pickle=True)
print("comparing archive contents")
s_in = archive['s']
assert s == s_in
# i_in = archive['i'][0]
# f_in = archive['f'][0]
# l_in = archive['l'][0]
# d_in = archive['d'][0]
# od_in = archive['od'][0]
# nda_in = archive['nda']
ut_in = archive['ut']
print(type(ut))
print(type(ut_in.item()))
# assert ut.attr_1 == ut_in
assert ut.attr_1 == ut_in.item().attr_1
# ut_array_in = archive['ut_array']
# print("Loaded types:")
# print("type(s_in):", type(s_in))
# print(s_in)
# print("type(i_in):", type(i_in))
# print(i_in)
# print("type(f_in):", type(f_in))
# print(f_in)
# print("type(l_in):", type(l_in))
# print(l_in)
# print("type(d_in):", type(d_in))
# print(d_in)
# print(d_in["key1"])
# print(d_in["key2"])
# print("type(od_in):", type(od_in))
# print(od_in)
# print(od_in["k1"])
# print(od_in["k2"])
#
# print("type(nda_in):", type(nda_in))
# print(nda_in)
# print("type(ut_in):", type(ut_in))
# print(ut_in)
# print("type(ut_array_in):", type(ut_array_in))
# print(ut_array_in)
# print(ut_array_in[0])
#print(ut_array_in[0].attr_1)