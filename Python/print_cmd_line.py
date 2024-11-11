"""Print the command line arguments

Example(s):

> print_cmd_line arg1 arg2 arg3

"""
import os
import sys
def main():
    print("sys.argv: ", sys.argv)
    print("#: value (leading and trailing single quotes are not part of the value)")
    print("=======================================================================")
    for i_arg, arg in enumerate(sys.argv):
        print("{}: '{}'".format(i_arg, arg))
    print(" ")
    print(sys.version_info)
    print(sys.getwindowsversion())
    print("PATH: ", repr(os.getenv('PATH')))
    input("Press Enter to exit")

if __name__ == "__main__":
    main()