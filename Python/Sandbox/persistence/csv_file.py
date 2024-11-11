description = """
A short description of the program.
"""
epilog = """
This text is presented below the arguments, it is a good place to list assumptions, requirements, side effects 
or discussions of the program.  If this text here is already formatted see the argparse.RawDescriptionHelpFormatter in 
http://docs.python.org/library/argparse.html#formatter-class
"""

"""
:author: Rick Gaudette
:date: Dec 15, 2010
"""

import csv
import os

if __name__ == "__main__":

    print os.getcwd()
    
#    header = ["Column1", "Column 2", "Column 3"]
#    r1 = [1, 2, 3]
#    r2 = ["A", "b", 23]
#    with open("test.csv", "wb") as file:
#        test_csv = csv.writer(file)
#        test_csv.writerow(header)
#        test_csv.writerow(r1)
#        test_csv.writerow(r2)

    with open("test.csv", "rb") as file:
        csv_reader = csv.reader(file)
        for row in csv_reader:
            print row
            
            