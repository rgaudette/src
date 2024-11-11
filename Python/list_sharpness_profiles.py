from glob import glob
def list_sharpness_profiles(rrID = None, fgID = None, level = None):
    if rrID:
        rrID_str = "%05d" % rrID
    else:
        rrID_str = "*"

    if fgID:
        fgID_str = "%d" % fgID
    else:
        fgID_str = "*"

    if level:
        level_str = "%d" % level
    else:
        level_str = "*"

    glob_string = "sharpness_R%s_F%s_L%s.txt" % (rrID_str, fgID_str, level_str)

    return glob(glob_string)
