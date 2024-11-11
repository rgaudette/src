using JLD

module AModule
struct MyType
    value::Int
    # s_array::SparseMatrixCSC
end
end

using MyTypes

x = MyType(3)

using SparseArrays
x = MyType(3, spdiagm(-1 => [1,2,3,4], 1 => [4,3,2,1]))

using JLD
jldopen("somedata.jld", "w") do file
    addrequire(file, MyTypes)
    addrequire(file, SparseArrays)
    write(file, "x", x)
end

d = load("somedata.jld")
