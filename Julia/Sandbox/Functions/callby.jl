# this code explores when or not the arguments of a function are modified by the callee
#
# include("callby.jl") to run the code
using Printf

# reshape the arrays and return a new reference and reference of the same name, in neither case does the calling argument change
function flatten(array_in::Array, array::Array)::Tuple{Array, Array}
    n = length(array_in)
    array_out = reshape(array_in, n)
    n = length(array)
    array = reshape(array, n)
    return array_out, array
end

a = ones(3, 3)
b = ones(3, 3)
@info("a:", a)
@info("b:", b)
y, z = flatten(a, b)
println("post call")
@info("a:", a)
@info("b:", b)
@info("y:", y)
@info("z:", z)

# This allocates a returns a new array and does not modify the calling arguments
function add_scalar(array::Array{T}, value::Number)::Array{T} where {T<:Number}
    array = array .+ value
    return array
end

# This DOES modify the calling argument array because it performs an in-place operation on array
function add_scalar!(array, value)
    array .+= value
    return array
end

# This modifies the contents of array but the reshape does not affect the calling
function modify_shape!(array, n_r, n_c)
    array = reshape(array, n_r, n_c)
    array[1] = 10
    return array
end

function double_value(a::T, double::Bool=true)::T where {T<:AbstractFloat}
    if double
        b = 2 * a
    else
        b = a
    end
    return convert(T, b)
end


# @printf("y: ", y)
# @printf("z: ", z)

# v = collect(1.0:6)
# println("v: ", v)
# u = modify_shape!(v, 2, 3)
# println("v: ", v)
# println("u: ", u)

# b = add_scalar(m, 2.0)
# println(m)
# println(b)

# c = add_scalar!(m, 3.0)
# println(m)
# println(c)

# println(typeof(double_value(1.0, false)))
# println(typeof(double_value(1.0, true)))
# println(typeof(double_value(1.0)))