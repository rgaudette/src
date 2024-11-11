from __future__ import division

import matplotlib.pyplot as plt
import numpy as np


def main():
    plt.interactive(True)
    plt.figure()
    plt.plot(np.arange(10))
    plt.draw()
    # show causes the execution to stop until the plot window(s?) is closed
    #plt.show()
    _ = raw_input("Press Enter to quit")


if __name__ == "__main__":
    main()
