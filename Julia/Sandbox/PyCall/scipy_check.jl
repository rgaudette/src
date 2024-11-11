using PyCall

so = pyimport("scipy.optimize")
res = so.newton(x -> cos(x) - x, 1)
println("result: ", res)
