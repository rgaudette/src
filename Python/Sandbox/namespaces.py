from __future__ import division



global_var1 = 'gv1'
global_var2 = 2

def my_func():
    #print("__name__ in my_func: ", __name__)
    #print("__module__ in my_func : ", __module__)
    dir()

if __name__ == '__main__':
    #print("__name__ in module : {}", __name__)
    #print("__module__ in module : ", __module__)
    print("local names")
    lk = locals().keys()
    for l in lk:
        print l
    print("")
    print("global names")
    gk = globals().keys()
    for g in gk:
        print g

    #my_func()
