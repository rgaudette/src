# Change to the working directory to the location of this file and create a data directory
cd(dirname(@__FILE__))
data_path = "data"
mkpath(data_path)

# read and write objects using the raw IO capabilities of Julia
int_out = 1
filename = joinpath(data_path, "int.dat")
open(filename, "w") do io
    write(io, int_out)
end
open(filename, "r") do io
    int_in = read(io, typeof(int_out))
    @assert int_out == int_in
end

float_out = 3.14
filename = joinpath(data_path, "float.dat")
open(filename, "w") do io
    write(io, float_out)
end
open(filename, "r") do io
    float_in = read(io, typeof(float_out))
    @assert float_out == float_in
end


# Create a 3x4 Float64 array
A_out = reshape(collect(1.0:12), 3, 4)
filename = joinpath(data_path, "float_array.dat")
open(filename, "w") do io
    write(io, A_out)
end
open(filename, "r") do io
    A_in = zeros(3, 4)
    read!(io, A_in)
    @assert all(A_out == A_in)
end

# Create a 3x4 Int64 array
A_out = reshape(collect(1:12), 3, 4)
filename = joinpath(data_path, "float_array.dat")
open(filename, "w") do io
    write(io, A_out)
end
open(filename, "r") do io
    A_in = zeros(Int64, 3, 4)
    read!(io, A_in)
    @assert all(A_out == A_in)
end

struct MyStruct
    an_int::Int64
    a_float::Float64
    str::String
end


ms_out = MyStruct(2, 4.2, "hello")
filename = joinpath(data_path, "my_struct.dat")
open(filename, "w") do io
    write(io, ms_out)
end
open(filename, "r") do io
    A_in = zeros(Int64, 3, 4)
    read!(io, A_in)
    @assert all(A_out == A_in)
end
