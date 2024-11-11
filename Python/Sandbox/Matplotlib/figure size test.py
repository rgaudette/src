import matplotlib
import matplotlib.pyplot as plt
import numpy as np

import sys
from packaging import version
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
    app.exec()
    # app.quit()

    return dpi, screen_scaling_factor


def main():
    figsize = (6, 4)

    # howlin DPI
    # dpi = 187
    # lenovo DPI
    # dpi = 216
    # viewsonic DPI
    # dpi = 163

    # How can we detect what screen the window is on?
    screen_id = 0
    screen_dpi, screen_scaling_factor = get_display_parameters(screen_id)
    print("Round 1 Using a screen DPI of {:0.1f} and scaling factor {:0.1f}".format(screen_dpi, screen_scaling_factor))

    # With Matplotlib >= 3.0,  If the Windows display scaling is greater than 125%, Matplotlib 3.X doubles the window
    # size in pixels greater than 225% Matplotlib 3.X triples the window size in pixels
    dpi_scaling = 1.0
    if version.parse(matplotlib.__version__) >= version.parse("3.0.0"):
        if screen_scaling_factor > 1.3:
            dpi_scaling = 2.0
        if screen_scaling_factor > 2.3:
            dpi_scaling = 3.0
    matplotlib_dpi = screen_dpi / dpi_scaling

    plt.figure(figsize=figsize, dpi=int(matplotlib_dpi))
    plt.plot(np.arange(10))
    plt.title('Figure 1 matplotlib version {}'.format(matplotlib.__version__))
    plt.xlabel('figsize: {}x{}, DPI: {:0.1f} Matplotlib DPI: {:0.1f}'.format(figsize[0], figsize[1], screen_dpi,
                                                                             matplotlib_dpi))
    plt.ylabel('numpy version: {}'.format(np.version.full_version))

    plt.show()


if __name__ == "__main__":
    main()
