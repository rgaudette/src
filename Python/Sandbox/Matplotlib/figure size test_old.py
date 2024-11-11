import matplotlib
import matplotlib.pyplot as plt
import numpy as np

import sys

from PyQt5.QtWidgets import QApplication


def get_display_parameters(screen_id):
    app = QApplication(sys.argv)
    for idx_screen, screen in enumerate(app.screens()):
        dpi = screen.physicalDotsPerInch()
        dev_pixel_ratio = screen.devicePixelRatio()
        logicalDotsPerInch = screen.logicalDotsPerInch()
        logicalDotsPerInchX = screen.logicalDotsPerInchX()
        logicalDotsPerInchY = screen.logicalDotsPerInchY()

        print('screen: {}'.format(idx_screen))
        print('  dpi: {}'.format(dpi))
        print('  dev_pixel_ratio: {}'.format(dev_pixel_ratio))
        print('  logicalDotsPerInch: {}'.format(logicalDotsPerInch))
        print('  logicalDotsPerInchX: {}'.format(logicalDotsPerInchX))
        print('  logicalDotsPerInchY: {}'.format(logicalDotsPerInchY))

    dpi = app.screens()[screen_id].physicalDotsPerInch()
    screen_scaling_factor = app.screens()[screen_id].logicalDotsPerInch() / 96



    return dpi, screen_scaling_factor


def main():
    figsize = (4, 3)
    # howlin DPI
    # dpi = 187
    # lenovo DPI
    screen_dpi, screen_scaling_factor = get_display_parameters(0)
    # dpi = 216 // 2
    # viewsonic DPI
    #screen_dpi, screen_scaling_factor = get_display_parameters(0)
    print("Using a screen DPI of {:0.3f} and scaling factor {:0.3f}".format(screen_dpi, screen_scaling_factor))

    # If the Windows display scaling is greater than 125%, Matplotlib 3.X doubles the window size in pixels
    # greater than 225% Matplotlib 3.X triples the window size in pixels
    # How does the scaling on the primary and secondary display affect this
    matplotlib_dpi = screen_dpi / screen_scaling_factor

    plt.figure(figsize=figsize, dpi=int(matplotlib_dpi))
    plt.plot(np.arange(10))
    plt.title('matplotlib version {}'.format(matplotlib.__version__))
    plt.xlabel('figsize: {}x{}, DPI: {:0.3f} Matplotlib DPI: {:0.3f}'.format(figsize[0], figsize[1], screen_dpi,
                                                                             matplotlib_dpi))
    plt.ylabel('numpy version: {}'.format(np.version.full_version))

    plt.show()


if __name__ == "__main__":
    main()
