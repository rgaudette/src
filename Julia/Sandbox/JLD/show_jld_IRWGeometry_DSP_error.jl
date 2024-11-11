# This script crashes
# Changing M* to Mutable* still crashes so it does not seem to be a name collision
# If using DSP is executed here then this script does not crash
# using DSP
using JLD

# If using DSP is executed here then this script does not crash
# using DSP

# using IRWGeometry
abstract type AbstractXYPair{T} end

"""
A basic X & Y Pair
"""
# struct XYPair{T <: Real} <: AbstractXYPair{T}
#     x::T
#     y::T
# end # XYPair

# XYPair(t::Tuple{T, T}) where {T <: Real} = XYPair{T}(t[1], t[2])

# Aliases for XYPair
# Point2D = XYPair
# Dimension2D = XYPair

"""
A basic mutable X & Y Pair
"""
mutable struct MXYPair{T <: Real} <: AbstractXYPair{T}
    x::T
    y::T
end # MXYPair

MXYPair(t::Tuple{T, T}) where {T <: Real} = MXYPair{T}(t[1], t[2])

# Aliases for MXYPair
# MPoint2D = MXYPair
# MDimension2D = MXYPair


abstract type AbstractRectangle{T} end
# """
# A basic 2D rectangle
# """
# struct Rectangle{T <: Real} <: AbstractRectangle{T}
#     origin::Point2D{T}
#     width::T
#     height::T
# end # Rectangle
# function Rectangle(origin_x::T, origin_y::T, width_in::T, height_in::T) where {T <: Real}
#     Rectangle{T}(Point2D{T}(origin_x, origin_y), width_in, height_in)
# end

"""
A mutable 2D rectangle
"""
mutable struct MRectangle{T <: Real} <: AbstractRectangle{T}
    origin::MXYPair{T}
    width::T
    height::T
end # Rectangle
# Outer constructors defining a different set of argument types
# function MRectangle(origin_x::T, origin_y::T, width_in::T, height_in::T) where {T <: Real}
#     MRectangle{T}(MPoint2D{T}(origin_x, origin_y), width_in, height_in)
# end

# xy_pair = XYPair(2.0, 3.0)
# point2d = Point2D(4.0, 5.0)
# dim2d = Dimension2D(6.0, 7.0)
# mxy_pair = MXYPair(2.0, 7.0)
# mpoint2d = MPoint2D(5.1, 3.2)
# mdim2d = MDimension2D(45.1, 12.0)
# rect = Rectangle(1.0, 2.0, 3.0, 4.0)
mrect = MRectangle(MXYPair(1.0, 2.0), 3.0, 4.0)

# If using DSP is executed here then this script does not crash
# using DSP
jldopen("show_jld_error.jld", "w") do file
    # addrequire(file, IRWGeometry)
    # write(file, "version_string", "1.0.0")
    # write(file, "xy_pair", xy_pair)
    # write(file, "point2d", point2d)
    # write(file, "dim2d", dim2d)
    # write(file, "mxy_pair", mxy_pair)
    # write(file, "mpoint2d", mpoint2d)
    # write(file, "mdim2d", mdim2d)
    # write(file, "rect", rect)
    write(file, "mrect", mrect)
end

# If the DSP module is loaded (using or import) JLD crashes on the following write
using DSP

jldopen("show_jld_error.jld", "w") do file
    # addrequire(file, IRWGeometry)
    # write(file, "version_string", "1.0.0")
    # write(file, "xy_pair", xy_pair)
    # write(file, "point2d", point2d)
    # write(file, "dim2d", dim2d)
    # write(file, "mxy_pair", mxy_pair)
    # write(file, "mpoint2d", mpoint2d)
    # write(file, "mdim2d", mdim2d)
    # write(file, "rect", rect)
    write(file, "mrect", mrect)
end
