from __future__ import division

import collections
l = [1,2,3]
d = {'a':1, 'b':2, 'c':3}
od = collections.OrderedDict()
od['a'] = 10
od['b'] = 20
od['c'] = 30

for l_,d_ in zip(l, d):
    print l_, d_

for l_,o_ in zip(l, od):
    print l_, o_
