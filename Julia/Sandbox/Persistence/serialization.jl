using Serialization

# Change to the working directory to the location of this file and create a data directory
cd(dirname(@__FILE__))
data_path = "data"
mkpath(data_path)

# read and write objects using the Serialization Julia package
int_out = 1
filename = joinpath(data_path, "int.jls")
open(filename, "w") do io
    serialize(io, int_out)
end
open(filename, "r") do io
    int_in = deserialize(io)
    @assert int_out == int_in
end

float_out = 3.14
filename = joinpath(data_path, "float.jls")
open(filename, "w") do io
    serialize(io, float_out)
end
open(filename, "r") do io
    float_in = deserialize(io)
    @assert float_out == float_in
end

# Each object written is preceeded by the serialization header
filename = joinpath(data_path, "int_and_float.jls")
open(filename, "w") do io
    serialize(io, int_out)
    serialize(io, float_out)
end
open(filename, "r") do io
    int_in = deserialize(io)
    @assert int_out == int_in
    float_in = deserialize(io)
    @assert float_out == float_in
end

# Create a 3x4 Float64 array
A_out = reshape(collect(1.0:12), 3, 4)
filename = joinpath(data_path, "float_array.jls")
open(filename, "w") do io
    serialize(io, A_out)
end
open(filename, "r") do io
    A_in = deserialize(io)
    @assert all(A_out == A_in)
end

# Integer arrays appear not to work, need to explore this more not a priority right now
# Create a 3x4 Int64 array
# A_out = reshape(collect(1:12), 3, 4)
# println(typof(A_out))
# filename = joinpath(data_path, "int_array.jls")
# open(filename, "w") do io
#     write(io, A_out)
# end
# open(filename, "r") do io
#     A_in = deserialize(io)
#     println(typeof(A_in))
#     println(A_out)
#     @warn A_out
#     println(A_in)
#     @warn A_in
#     @assert all(A_out == A_in)
# end

struct MyStruct
    an_int::Int64
    a_float::Float64
    str::String
end

ms_out = MyStruct(2, 4.2, "hello")
filename = joinpath(data_path, "my_struct.jls")
open(filename, "w") do io
    serialize(io, ms_out)
end
open(filename, "r") do io
    ms_in = deserialize(io)
    @assert ms_out.an_int == ms_in.an_int
    @assert ms_out.a_float == ms_in.a_float
    @assert ms_out.str == ms_in.str
    # this will only hold true if MyStruct is immutable
    @assert ms_out == ms_in
end
