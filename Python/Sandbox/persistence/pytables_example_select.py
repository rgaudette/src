'''
Created on Jul 26, 2010

@author: rick
'''

import numpy as np
from tables import *

h5file = openFile("simple.h5", mode = "r")
table = h5file.root.InspectionRes
#da = 
#dj = [ x['panel/defective_joints'] for x in table.iterrows()  if '18:5' in x['date_and_time'] ]
#dc = [ x['panel/defective_components'] for x in table.iterrows()  if '18:5' in x['date_and_time'] ]

da = list()
dj = list()
dc = list()
ref_des = list()
for r in table.iterrows():
    if '18:' in r['date_and_time']:
        da.append(r['date_and_time'])
        dj.append(r['panel/defective_joints'])
        dc.append(r['panel/defective_components'])
        ref_des.append(r["board/component/ref_des"])
print da
print dj
print dc
print ref_des
