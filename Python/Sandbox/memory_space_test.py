"""
Created on Dec 14, 2009

@author: Rick Gaudette
"""
import random
import gc

#def get_memory():
#    import os
#    from wmi import WMI
#    w = WMI('.')
#    result_list = w.query("SELECT WorkingSet FROM Win32_PerfRawData_PerfProc_Process WHERE IDProcess=%d" % os.getpid())
#    result_item = result_list[0]
#    ws = int(result_item.WorkingSet) / 1024 
#    return ws

if __name__ == '__main__':
#    print("Working set: {0} kB". format(get_memory()))
    n_blocks_max = 50
    block_size = 100000000 / 8
    block_list = list()
    for i in range(0,n_blocks_max):
        print("Block id: {0}".format(i))
        j = 0
        block = list()
        while j < block_size:
            block.append(random.random())
            j = j + 1
#        print("Working set: {0} kB". format(get_memory()))
        block_list.append(block)
        del(block)
        gc.collect()
#        print("Working set: {0} kB". format(get_memory()))
        gc.collect()
        