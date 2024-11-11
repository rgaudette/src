using JLD

using IRWGeometry

i = 1

f = π

s = "a string"

xypair = XYPair(1.0, 2.0)
mxypair = MXYPair(3, 4)

compress=true
second_write_compress=true

filename = "append_test.jld"

# save(filename, "i", i, "f", f)
jldopen(filename, "w", compress=compress) do jld_file
    addrequire(jld_file, IRWGeometry)
    write(jld_file, "i", i)
    write(jld_file, "f", f)
    write(jld_file, "xypair", xypair)

end

first_dict = load(filename)
@assert i == first_dict["i"]
@assert f == first_dict["f"]
@assert xypair == first_dict["xypair"]
# This only holds when the XYPair is immutable
@assert xypair === first_dict["xypair"]

# This overwrites the existing variables
# save(filename, "s", s)
jldopen(filename, "r+", compress=second_write_compress) do jld_file
    write(jld_file, "s", s)
    write(jld_file, "mxypair", mxypair)
end
second_dict = load(filename)
println(keys(second_dict))
@assert s == second_dict["s"]
@assert i == second_dict["i"]
@assert f == second_dict["f"]
@assert xypair == first_dict["xypair"]
# This only holds when the XYPair is immutable
@assert xypair === first_dict["xypair"]

@assert mxypair == second_dict["mxypair"]

