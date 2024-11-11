using PyPlot

f = figure()
x = range(0; stop = 2 * pi, length = 1000);
y = sin.(3 * x + 4 * cos.(2 * x));
plot(x, y, color = "red", linewidth = 2.0, linestyle = "--")
title("A sinusoidally modulated sinusoid")

savefig("savefig_test.png", bbox_inches = "tight", pad_inches = 0.1)
show()
