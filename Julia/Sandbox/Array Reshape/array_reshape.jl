using Random
using BenchmarkTools

n_rows = 1000
n_cols = 1000
a = rand(n_rows, n_cols)
println(a[1])

function reshape_array(a, n_rows, n_cols)
    @btime b = reshape(a, n_rows * n_cols)
    b = reshape(a, n_rows * n_cols)
    b[1] = 0.0
    println(a[1])
end

function reshape_vec(a, n_rows, n_cols)
    @btime v = vec(a)
    v = vec(a)
    v[1] = 1.0
    println(a[1])
end

reshape_array(a, n_rows, n_cols)
reshape_vec(a, n_rows, n_cols)

v = rand(n_rows * n_cols)
reshape_array(v, n_rows, n_cols)
reshape_vec(v, n_rows, n_cols)

println("done")