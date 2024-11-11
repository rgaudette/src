'''
Created on Nov 11, 2009

@author: rick
'''
import operator
import collections

def dictionaries():
    keys = ['a', 'b', 'c']
    dictionary = dict()
    for idx, key in enumerate(keys):
        dictionary[key] = len(keys) - idx
    
    print("Unsorted")
    for key, val in dictionary.iteritems():
        print("{} {}".format(key, val))

    # Sorting a dictionary, the returned value is a sorted list of tuples
    sorted_by_keys = sorted(dictionary.iteritems(), key=operator.itemgetter(0))
    sorted_by_values = sorted(dictionary.iteritems(), key=operator.itemgetter(1))

    print("sorted by keys")
    for pair in sorted_by_keys:
        print("{} {}".format(pair[0], pair[1]))

    print("sorted by values")
    for pair in sorted_by_values:
        print("{} {}".format(pair[0], pair[1]))

    print("maximum")
    print max(dictionary)

    #sorted(student_tuples, key=lambda student: student[2])
    # Python 3 style views
    #for key, val in iter(dictionary.item()):

def ordered_dictionaries():
    keys = ['a', 'b', 'c']
    ordered_dict = collections.OrderedDict()
    for idx, key in enumerate(keys):
        ordered_dict[key] = len(keys) - idx

    # Iterating over the dictionary
    print("Iterating an Ordered Dictionary, produces keys in order")
    for keys in ordered_dict:
        print keys
    
    # Iterating over the dictionary
    print("itermitems() an Ordered Dictionary, produces keys and values in order")
    for key, value in ordered_dict.iteritems():
        print key, value

    # Enumerating the dictionary
    print("Enumerated Ordered Dictionary, returns the index of the item as well")
    for idx, key in enumerate(ordered_dict):
        value = ordered_dict[key]
        print idx, key, value


            
if __name__ == "__main__":
    dictionaries()
    ordered_dictionaries()
    