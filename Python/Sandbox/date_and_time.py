'''
Created on Aug 5, 2010

@author: rick
'''
import datetime
import time

if __name__ == '__main__':
    dt1 = datetime.datetime(2010, 1, 1, 0, 0, 0)
    print dt1
    dt2 = datetime.datetime(2010, 1, 1, 0, 1, 0)
    print dt2
    
    
    t1 = time.strptime("2010-05-20_18-40-33", "%Y-%m-%d_%H-%M-%S")
    print t1
    t2 = time.strptime("2010-05-20_18-42-19-75", "%Y-%m-%d_%H-%M-%S-%f")
    print t2
    delta = time.mktime(t2) - time.mktime(t1)
    print delta
