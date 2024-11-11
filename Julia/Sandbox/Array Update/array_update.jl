using BenchmarkTools

function accumulate_with_colon!(a::AbstractArray{T}, b::AbstractArray{T}, n) where {T <: Real}
    # println("a in the function: ", pointer(a))
    for i = 1:n
        # a[:] += b
        a[:] = a + b
        # println("a in the loop: ", pointer(a))
    end
    # println("a in the function: ", pointer(a))
end

function accumulate_return(a::AbstractArray{T}, b::AbstractArray{T}, n)::AbstractArray{T} where {T <: Real}
    # println("a in the function: ", pointer(a))
    for i = 1:n
        a = a + b
        # println("a in the loop: ", pointer(a))
    end
    # println("a in the function: ", pointer(a))
    return a
end

function accumulate_update!(a::AbstractArray{T}, b::AbstractArray{T}, n)::Nothing  where {T <: Real}
    # println("a in the function: ", pointer(a))
    for i = 1:n
        a .+= b
        # println("a in the loop: ", pointer(a))
    end
    return nothing
end


n_rows = 1_000
n_cols = n_rows
n = 10

println("accumulate_update!:")
a = zeros(n_rows, n_cols)
b = ones(n_rows, n_cols)
print("@btime")
@btime accumulate_update!(a, b, n)

# println("a before accumulate_update!: ", pointer(a))
a = zeros(n_rows, n_cols)
b = ones(n_rows, n_cols)
print("@time")
@time accumulate_update!(a, b, n)
# println("a after accumulate_with_colon!: ", pointer(a))
println("All a = n:", all(a .≈ Float64(n)))
println("")


println("accumulate_return:")
a = zeros(n_rows, n_cols)
b = ones(n_rows, n_cols)
print("@btime")
@btime begin
    global a
    a = accumulate_return(Main.a, b, n)
end

a = zeros(n_rows, n_cols)
b = ones(n_rows, n_cols)
print("@time")
@time begin
    # global a
    # println("a in the block: ", pointer(a))
    a = accumulate_return(a, b, n)
    # println("a at the end: ", pointer(a))
end
println("All a = n:", all(a .≈ Float64(n)))
println("")


println("accumulate_with_colon!:")
a = zeros(n_rows, n_cols)
b = ones(n_rows, n_cols)
print("@btime")
@btime accumulate_with_colon!(a, b, n)
# println("a before accumulate_with_colon!: ", pointer(a))

a = zeros(n_rows, n_cols)
b = ones(n_rows, n_cols)
print("@time")
@time accumulate_with_colon!(a, b, n)
# println("a after accumulate_with_colon!: ", pointer(a))
println("All a = n:", all(a .≈ Float64(n)))
println("")


