"""
Created on Dec 11, 2009

@author: Rick Gaudette
"""

import numpy as np
class MyObject(object):
    
    def __init__(self):
        self.a_list = [1,2,3,4]
        self.a_array = np.array(self.a_list)
        self.b_list = np.arange(1.0,16.0E6,1.0)
        
def get_memory():
    import os
    from wmi import WMI
    w = WMI('.')
    result_list = w.query("SELECT WorkingSet FROM Win32_PerfRawData_PerfProc_Process WHERE IDProcess=%d" % os.getpid())
    result_item = result_list[0]
    ws = int(result_item.WorkingSet) / 1024 
    return ws
    
    
if __name__ == '__main__':
    print("Working set {0}k".format(get_memory()))
    mo = MyObject()
    print mo.__sizeof__()
    print("Working set {0}k".format(get_memory()))
