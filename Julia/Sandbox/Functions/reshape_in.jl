function vectorize(a)
    return reshape(a, :)
end

function vectorize!(a)
    a = reshape(a, :)
end

function vectorize_colon!(a)
    a[:] = reshape(a, :)
end

function scale(a, f)
    return a * f
end

function scale!(a, f)
    a = a * f
end

function scale_colon!(a, f)
    a[:] = a * f
end

z = reshape(collect(1.0:12), 3, 4)
println("z")
println(z)

println("calling vectorize")
y = vectorize(z)
println("z")
println(z)
println("y")
println(y)

println("calling vectorize!")
vectorize!(z)
println("z")
println(z)

println("calling vectorize_colon!")
vectorize_colon!(z)
println("z")
println(z)

z = reshape(collect(1:12), 3, 4)
println("z")
println(z)

println("calling scale")
y = scale(z, 2.0)
println("z")
println(z)
println("y")
println(y)

println("scale!")
scale!(z, 2.0)
println("z")
println(z)

println("calling scale!")
scale_colon!(z, 2.0)
println("z")
println(z)
println(typeof(z))
