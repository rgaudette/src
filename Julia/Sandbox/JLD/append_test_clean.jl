# run this in a clean julia instance so that all of the necessary types are ensured to be in the jld files
using JLD
filename = "append_test.jld"
first_dict = load(filename)
