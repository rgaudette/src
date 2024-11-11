from __future__ import division

"""
Different parameter file techniques
:author: Rick Gaudette
:date: 2011-07-07 
"""
A_PARAMETER = None
#global A_PARAMETER

def main():

    ## Load another python file using execfile, this imports the parameters into the global namespace for the module
    execfile('parameter_files_py.py', globals())
    print A_PARAMETER
    
if __name__ == '__main__':
    main()