'''
Created on Jul 25, 2010

@author: rick
'''
import glob
import os
import numpy as np
from tables import *
import xml.sax 

class MeasurementsParser(xml.sax.handler.ContentHandler, object):
    def __init__(self, table):
        self.table = table
    
    def startDocument(self):
        self.row = self.table.row
    
    def endDocument(self):
        self.row.append()
        
#    def _parse_panel_element(self, name, attrs):
#        self.row["panel/defective_joints"] = int(attrs.getValue("defectiveJoints").strip())
#        self.row["panel/defective_components"] = int(attrs.getValue("defectiveComponents").strip())

#    def _parse_inspectionResults_element(self, name, attrs):
#        self.row["date_and_time"] = attrs.getValue("dateAndTime").strip()
#        self.row["mode"] = attrs.getValue("mode").strip()
    
    def startElement(self, name, attrs):
        if name == "component":
            ##self._parse_panel_element(name, attrs)
            print attrs.getValue("refDes").strip()
            self.row["board/component/ref_des"] = attrs.getValue("refDes").strip()
            return

        if name == "board":
            ##self._parse_panel_element(name, attrs)
            self.row["board/name"] = attrs.getValue("name").strip()
            return

        if name == "panel":
            ##self._parse_panel_element(name, attrs)
            self.row["panel/defective_joints"] = int(attrs.getValue("defectiveJoints").strip())
            self.row["panel/defective_components"] = int(attrs.getValue("defectiveComponents").strip())
            return
        
        if name == "inspectionResults":
            self.row["date_and_time"] = attrs.getValue("dateAndTime").strip()
            self.row["mode"] = attrs.getValue("mode").strip()
            ##self._parse_inspectionResults_element(name, attrs)
            return

#class Component(IsDescription):            
#    ref_des = StringCol(80)
    
class Component(IsDescription):            
    ref_des = StringCol(80)
    
class Board(IsDescription):            
    name = StringCol(80)
    component = Component()
    
class Panel(IsDescription):
    defective_joints = IntCol()
    defective_components = IntCol()
    
        
class InspectionResults(IsDescription):
    date_and_time = StringCol(25)
    mode = StringCol(80)
    panel = Panel()
    # How to store multiple boards
    board = Board()
    
if __name__ == '__main__':
    max_files = 1
    
    search_path = "H:/Users/rick/AXI/Jabil AVL Evaluation/RN5 U27 U31 Alignment/S31196/Normal"
    print search_path
    glob_string = os.path.join("H:/Users/rick/AXI/Jabil AVL Evaluation/RN5 U27 U31 Alignment/S31196/Normal/", "*/*/*measurements.xml")
    print glob_string
    
    measurement_files = glob.glob(glob_string)
    if max_files is not None and len(measurement_files) > max_files:
        measurement_files = measurement_files[0:max_files]
    print measurement_files
    
    fileh = openFile("simple.h5", "w")
    table = fileh.createTable(fileh.root, 'InspectionRes', InspectionResults)    
    mp = MeasurementsParser(table)

    parser = xml.sax.make_parser()
    parser.setContentHandler(mp)

    for path in measurement_files:
        print(path)
        parser.parse(path)

    table.flush()
    
    
