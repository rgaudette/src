'''
Created on Oct 29, 2009

@author: rick
'''

def func_arguments(required_1, required_2, default_1="Nothing", default_2="Not set", *the_rest):
    print("required_1: {0}".format(required_1))
    print("required_2: {0}".format(required_2))
    print("default_1: {0}".format(default_1))
    print("default_2: {0}".format(default_2))
    print("The rest:")
    print(the_rest)

def append_keywords(**kwargs):
    kwargs["default_1"] = "appended"
    print kwargs
    func_arguments("r1", "r2", **kwargs)

def default_arguments(arg1 = 1, constructed = list(), correct = None):
    print arg1
    print constructed
    this_correct = correct if correct is not None else list()
    print this_correct
    return arg1, constructed, this_correct

def return_values(arg1, arg2):
    return_value = arg1 + arg2
    arg2
    return return_value

def call_by_value_change_object(collection_1):
    # Trim the elements changing the
    collection_ret = collection_1[1:-1]
    return collection_ret

def call_by_value_change_internal(collection_1):
    # Because the value of the call is a reference to the object identified by collection_1,
    # changing it's internal structure changes the object
    collection_1[0] = 0
    return collection_1

def call_by_value_reassign_formal_parameter(collection_1):
    # Reassigning the formal parameter reference does not change the underlying object
    collection_1 = collection_1[1:]
    return collection_1

if __name__ == "__main__":
    print("All defined, no keywords")
    func_arguments("p1", "p2", "default_1", "default_2")
    
    print("All defined, reverse order keywords")
    func_arguments("p1", "p2", default_2="first", default_1="second")

    print("\nNo default_2")
    func_arguments("p1", "p2", default_1="default_1")
    
    print("\nNo default_1")
    func_arguments("p1", "p2", default_2="default_2")
    
    #print("\nNo p2")  This is an error
    #func_arguments("p1", default_1="default_1", default_2="default_2")
    
    print("\nNo keywords, some variables")
    func_arguments("p1", "p2", "p3", "p4", "p5")
    
    print("\nAppended keywords")
    append_keywords(default_2="Original")
    
    print("Default arguments")
    arg1, constructed, this_correct = default_arguments()
    constructed.append(1)
    this_correct.append(1)
    arg2, constructed2, this_correct2 = default_arguments()

    print("Call by value example")

    l = range(1,5)
    print("function argument")
    print l
    l_ret = call_by_value_change_object(l)
    print("function argument after call to call_by_value_change_object")
    print l
    print("returned value after call to call_by_value_change_object")
    print l_ret

    print("function argument")
    print l
    l_ret = call_by_value_change_internal(l)
    print("function argument after call to call_by_value_change_object")
    print l
    print("returned value after call to call_by_value_change_object")
    print l_ret

    print("function argument")
    print l
    l_ret = call_by_value_reassign_formal_parameter(l)
    print("function argument after call to call_by_value_reassign_formal_parameter")
    print l
    print("returned value after call to call_by_value_reassign_formal_parameter")
    print l_ret