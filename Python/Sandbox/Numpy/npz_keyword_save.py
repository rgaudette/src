# This works
from numpy import *

test1 = arange(3.0)
test2 = arange(4.0)
kwd_dict = dict()
kwd_dict['test1'] = test1
kwd_dict['test2'] = test2
savez('test.npz', **kwd_dict)

archive = load('test.npz')

print(archive.files)
