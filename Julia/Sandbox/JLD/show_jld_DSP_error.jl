# This script works fine
using JLD

using SparseArrays

jldopen("show_jld_error.jld", "w") do file
    # addrequire(file, IRWGeometry)
    addrequire(file, SparseArrays)
    write(file, "version_string", "1.0.0")
end

# Validate that the output file can be read
# output_dict = load("show_jld_error.jld")

using DSP

jldopen("show_jld_error.jld", "w") do file
    # addrequire(file, IRWGeometry)
    addrequire(file, SparseArrays)
    write(file, "version_string", "1.0.0")
end