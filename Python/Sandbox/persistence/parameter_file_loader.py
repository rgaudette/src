# Load in the parameter file
import parameter_file
# Make sure we have the latest
reload(parameter_file)
# put the objects into the current name space
from parameter_file import *

print(test_name)
print(test_param_1)