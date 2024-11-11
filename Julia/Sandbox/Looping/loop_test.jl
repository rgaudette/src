
v = 1
for i = 1:10
    global v += 1
end
println("v:", v)

function test_access(n)
    u = 1
    for i = 1:n
        u += 1
    end
    return u
end

r = test_access(4)
println("r: ", r)
