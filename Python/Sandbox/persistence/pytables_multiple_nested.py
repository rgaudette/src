'''
Created on Jul 26, 2010

@author: rick
'''
import tables

class Component(tables.IsDescription):            
    attrib1 = tables.IntCol()
    attrib2 = tables.IntCol()
    row_id = tables.IntCol()
        
class Board(tables.IsDescription):            
    attrib1 = tables.IntCol()
    attrib2 = tables.IntCol()
    row_id = tables.IntCol()
        
class Panel(tables.description.IsDescription):
    attrib1 = tables.IntCol()
    attrib2 = tables.IntCol()
    
    
if __name__ == "__main__":
    fileh = tables.openFile("nested.h5", "w")
    panel_table = fileh.createTable(fileh.root, 'panel', Panel)
#    board_table = fileh.createTable(fileh.root, 'board', Panel)
    
    panel_row = panel_table.row
    panel_row["attrib1"] = 1
    panel_row["attrib2"] = 2
    print(panel_table.nrows)
    panel_row.append()
    print(panel_table.nrows)
    print(panel_table.nrows)
#    row["boards/attrib1"] = 3
#    row["boards/attrib2"] = 4
#    row.append()
#    
#    row["boards/attrib1"] = 5
#    row["boards/attrib2"] = 6
#    row.append()
#    
    panel_row = panel_table.row
    panel_row["attrib1"] = -1
    panel_row["attrib2"] = -2
    print(panel_table.nrows)
    panel_row.append()
    print(panel_table.nrows)
    panel_table.flush()
    print(panel_table.nrows)
#    row["boards/attrib1"] = 3
#    row["boards/attrib2"] = 4
#    row.append()
#    
#    row["boards/attrib1"] = 5
#    row["boards/attrib2"] = 6
#    row.append()
#            
    panel_table.flush()
 
    print "This Table"
    for r in panel_table.iterrows():
        print("panel.attrib1: {0}".format(r['attrib1']))
        print("panel.attrib2: {0}".format(r['attrib2']))
#        print("panel.boards.attrib1: {0}".format(r['boards/attrib1']))
#        print("panel.boards.attrib2: {0}".format(r['boards/attrib2']))
#        
    print panel_table.description
    
    fileh.close()
