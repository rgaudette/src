using JLD

# Change to the working directory to the location of this file and create a data directory
cd(dirname(@__FILE__))
data_path = "data"
mkpath(data_path)

# read and write objects using the JLD Julia package
int_out = 1
filename = joinpath(data_path, "int.jld")
save(filename, "int_out", int_out)
int_in = load(filename, "int_out")
@assert int_out == int_in

# use the dictionary form of load
jld_dict = load(filename)
@assert int_out == jld_dict["int_out"]

float_out = 3.14
filename = joinpath(data_path, "float.jld")
save(filename, "float_out", float_out)
float_in = load(filename, "float_out")
@assert float_out == float_in

# Multiple data in the same file
filename = joinpath(data_path, "int_and_float.jld")
save(filename, "int_out", int_out, "float_out", float_out)
file_dict = load(filename)
int_in = file_dict["int_out"]
float_in = file_dict["float_out"]
@assert int_out == int_in
@assert float_out == float_in

# Create a 3x4 Float64 array
A_out = reshape(collect(1.0:12), 3, 4)
filename = joinpath(data_path, "float_array.jld")
save(filename, "A_out", A_out)
A_in = load(filename, "A_out")
@assert all(A_out == A_in)


# Integer arrays appear not to work, need to explore this more not a priority right now
# Create a 3x4 Int64 array
A_out = reshape(collect(1:12), 3, 4)
filename = joinpath(data_path, "int_array.jld")
save(filename, "A_out", A_out)
A_in = load(filename, "A_out")
@assert all(A_out == A_in)


struct MyStruct
    an_int::Int64
    a_float::Float64
    str::String
end

ms_out = MyStruct(2, 4.2, "hello")
filename = joinpath(data_path, "my_struct.jld")
save(filename, "ms_out", ms_out)
ms_in = load(filename, "ms_out")
@assert ms_out.an_int == ms_in.an_int
@assert ms_out.a_float == ms_in.a_float
@assert ms_out.str == ms_in.str
# this will only hold true if MyStruct is immutable
@assert ms_out == ms_in

# Save several variables using a dictionary
a1 = collect(1:10)
a2 = collect(1.0:0.5:20.0)
d = Dict()
d["a1"] = a1
d["a2"] = a2
filename = joinpath(data_path, "dict_save.jld")
save(filename, d)
dict_save = load(filename)
@assert dict_save["a1"] == a1
@assert dict_save["a2"] == a2
