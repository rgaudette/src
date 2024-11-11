'''
Created on Sep 23, 2009

@author: rick
'''

def for_loop():

    a_list = range(4)
    for i, item in enumerate(a_list):
        print("%d, %d" % (i, item))
    print("Loop is done")
    print("%d, %d" % (i, item))


def modified_loop_variable():
    a_list = range(5)
    for val in a_list:
        print("initial value: {}".format(val))
        val *= -1
        print("modified value: {}".format(val))
if __name__ == "__main__":
    for_loop()
    modified_loop_variable()