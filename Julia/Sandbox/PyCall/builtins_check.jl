using PyCall

math = pyimport("math")
root_2_inv = math.sin(math.pi / 4)
println("root_2_inv: ", root_2_inv)
