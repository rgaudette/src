#import sub_module.a_module
from sub_module.a_module import value, a_function, AClass

a_val = value
print(a_val)

a_function("The argument")
a_class = AClass()

print(dir(AClass))
