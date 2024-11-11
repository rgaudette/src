
using JLD

# If using DSP is executed here then this script does not crash
# using DSP

# If the following 2 structs are not mutable, this script does not crash
"""
A basic mutable X & Y Pair
"""
mutable struct MXYPair{T <: Real}
    x::T
    y::T
end # MXYPair

"""
A mutable 2D rectangle
"""
mutable struct MRectangle{T <: Real}
    origin::MXYPair{T}
    width::T
    height::T
end # Rectangle

mrect = MRectangle(MXYPair(1.0, 2.0), 3.0, 4.0)

# If using DSP is executed here then this script does not crash
# using DSP
jldopen("file1.jld", "w") do file
    write(file, "mrect", mrect)
end

# If the DSP module is loaded (using or import) JLD crashes on the following write
using DSP

jldopen("file2.jld", "w") do file
    write(file, "mrect", mrect)
end
