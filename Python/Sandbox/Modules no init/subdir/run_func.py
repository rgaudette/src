
import sys
sys.path.append("..")

from file_module import func
import another_file

func(3.14)
print("initial another_file.global_parameter:", another_file.global_parameter)
another_file.global_parameter = -1.0 * another_file.global_parameter
print(another_file.global_parameter)
another_file.func2(-1)
