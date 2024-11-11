using PyCall
pygui(:qt5)
using PyPlot


fig, ax = plt.subplots(constrained_layout=true)
x = collect(range(0.0, 360.0, step=1.))
y = sin.(2. * x * π / 180.)
ax.plot(x, y)
ax.set_xlabel("angle [degrees]")
ax.set_ylabel("signal")
ax.set_title("Sine wave")


function deg2rad(x)
    return x * π / 180.
end


function rad2deg(x)
    return x * π / 180.
end

secax = ax.secondary_xaxis("top", functions=(deg2rad, rad2deg))
secax.set_xlabel("angle [rad]")
# plt.show()