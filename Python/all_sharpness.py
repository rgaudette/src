from matplotlib.pyplot import *
from parse_ids_from_filename import parse_ids_from_filename
from plot_sharpness import plot_sharpness
from matplotlib.pyplot import title
from matplotlib.pyplot import xlabel
from list_sharpness_profiles import  list_sharpness_profiles

def all_sharpness(rrID=None, fgID=None, search_dir = '', line_properties = None, title_prefix = ''):
    """
    Plot all of the sharpness profiles for focus group
    """

    if not rrID and not fgID:
        raise ValueError("Neither the RRID or FGID was specified")

    sharpness_files = list_sharpness_profiles(rrID, fgID)

    clf()

    n_levels = len(sharpness_files)
    for i in range(n_levels):
        subplot(n_levels, 1, n_levels - i)
        plot_sharpness(sharpness_files[i], 'marker', 'o', 'linestyle', 'None')
        ylim(ymin = 0)
        grid(True)
        rrid,fgid,level = parse_ids_from_filename(sharpness_files[i])
        title("%s RRID=%d FGID=%d Level=%d" % (title_prefix, rrid, fgid, level))
        xlabel("Z (mils)")
        ylabel("Sharpness")
