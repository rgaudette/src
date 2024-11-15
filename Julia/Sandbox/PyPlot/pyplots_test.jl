using PyCall
pygui(:qt5)
println(pygui())
# pygui(true)
using PyPlot
println(pygui())
# rcParams = PyPlot.PyDict(PyPlot.matplotlib."rcParams")
# rcParams["backend"] = "qt5"

# use x = linspace(0,2*pi,1000) in Julia 0.6
x = range(0; stop=2*pi, length=1000); y = sin.(3 * x + 4 * cos.(2 * x));
plot(x, y, color="red", linewidth=2.0, linestyle="--")
title("A sinusoidally modulated sinusoid")
show()
