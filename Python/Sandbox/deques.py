import collections


d1 = collections.deque()
d1.append(-1)
d1.append(-2)
d1.append(-3)

for e in d1:
    print e

v = d1.pop()
print v
print len(d1)

# This does not work, as the deque is not allowed to mutate during iteration
# RuntimeError: deque mutated during iteration
#for e in d1:
#    v = d1.pop()
#    print v

while len(d1) > 0:
    v = d1.pop()
    print v
    