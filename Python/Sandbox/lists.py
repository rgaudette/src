'''
Created on Nov 13, 2009

@author: rick
'''

# Removing an item from a list
def remove_item_1(l):
    for i, _ in enumerate(l):
        if i == 1:
            del l[i]

a_list = ['a', 'b', 'c']

# Printing examples
print(" ".join(a_list))
print("\n".join(a_list))
print("first element {0}".format(a_list[0]))
print("last element {0}".format(a_list[-1]))

remove_item_1(a_list)
print a_list

# Extending a list with another
a_list = ['a', 'b', 'c']
another = ['d','e','f']
a_list.extend(another)
print a_list