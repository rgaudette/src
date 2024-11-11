"""
"""
num_list = range(0, 10)
print num_list

# Apply an expression to each element of the list creating a new list
doubled = [2 * x for x in num_list]
print doubled

# Similarly, call a function on each element of the list creating a new list
hexed = [hex(x) for x in num_list]
print hexed

# Filter a list 
def is_big(x):
    return x > 4
big = [x for x in num_list if is_big(x)]
print big

# Combine both a filter and map operation
big_hexed = [ hex(x)
              for x in num_list
              if is_big(x) ]
print big_hexed
