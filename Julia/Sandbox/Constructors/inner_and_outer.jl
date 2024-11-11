using Test

""" A basic 2D point
"""
struct XYPair{T<:Real}
    x::T
    y::T
end
# Aliases for XYPair
Point2D = XYPair
Dimension2D = XYPair


"""A basic 2D rectangle
"""
struct Rectangle{T<:Real}
    origin::Point2D{T}
    length::T
    width::T
end
# Outer constructors defining a different set of argument types
Rectangle(origin_x::T, origin_y::T, length_in::T, width_in::T) where {T<:Real} =
    Rectangle{T}(Point2D{T}(origin_x, origin_y), length_in, width_in)


struct AbsorptionMap{T<:Real}
    rectangle::Rectangle{T}
    voxel_size::Point2D{T}
    x_sample_loc::StepRangeLen{T,Base.TwicePrecision{T},Base.TwicePrecision{T}}
    y_sample_loc::StepRangeLen{T,Base.TwicePrecision{T},Base.TwicePrecision{T}}

    map::Array{T, 2}

    function AbsorptionMap{T}(rectangle::Rectangle{T}, voxel_size::Point2D{T}) where {T<:Real}
        x_sample_loc = rectangle.origin.x:voxel_size.x:rectangle.origin.x+rectangle.length
        y_sample_loc = rectangle.origin.y:voxel_size.y:rectangle.origin.y+rectangle.length
        map = zeros(T, length(y_sample_loc), length(x_sample_loc))
        new(rectangle, voxel_size, x_sample_loc, y_sample_loc, map)
    end
end
AbsorptionMap(rectangle::Rectangle{T}, voxel_size::Point2D{T}) where {T<:Real} = AbsorptionMap{T}(rectangle, voxel_size)


function test_Point2D()
    p = Point2D(2.0, 3.0)
    return p.x == 2.0 && p.y == 3.0
end

function test_Dimension2D()
    d = Dimension2D(4, 5)
    return d.x == 4 && d.y == 5
end

function test_AbsorptionMap()
    am_rect = Rectangle(-3.0, -2.0, 5.0, 7.0)
    am_dim = Dimension2D(0.5, 1.25)

    am_explicit = AbsorptionMap{Float64}(am_rect, am_dim)
    am_implicit = AbsorptionMap(am_rect, am_dim)
    println(collect(am_implicit.x_sample_loc))

    return true
end

@testset "inner_and_outer" begin
    @test test_Point2D()
    @test test_Dimension2D()
    @test test_AbsorptionMap()
end
