using Test

""" A basic 2D point
"""
struct Point_2D
    x
    y
end
Dimension_2D = Point_2D

"""A basic 2D rectangle
"""
struct Rectangle
    origin::Point_2D
    length
    width
end
# Outer constructors defining a different set of argument types
Rectangle(origin_x, origin_y, length_in, width_in) = Rectangle(Point_2D(origin_x, origin_y), length_in, width_in)

struct AbsorptionMap
    rectangle::Rectangle
    voxel_size::Point_2D
    x_sample_loc
    y_sample_loc

    # map::Array{T, 2}
    # AbsorptionMap(rectangle::Rectangle , voxel_size::Point_2D ) = new(rectangle, voxel_size, 0.5:0.5:2.5, 0.5:0.5:2.5)
    # AbsorptionMap (rectangle::Rectangle , voxel_size::Point_2D ) = new(rectangle, voxel_size)#, 0.5:0.5:2.5, 0.5:0.5:2.5)
end
AbsorptionMap(rectangle::Rectangle, voxel_size::Point_2D) = AbsorptionMap(rectangle, voxel_size, 0.5:0.5:2.5, 0.5:0.5:2.5)

function test_Point_2D()
    p = Point_2D(2.0, 3.0)
    return p.x == 2.0 && p.y == 3.0
end

function test_Dimension_2D()
    d = Point_2D(4, 5)
    return d.x == 4 && d.y == 5
end


function test_AbsorptionMap()
    am_rect = Rectangle(-3.0, -2.0, 5.0, 7.0)
    am_dim = Dimension_2D(0.5, 1.25)
    am = AbsorptionMap(am_rect, am_dim)
    return true
end

@testset "inner_and_outer" begin
    @test test_Point_2D()
    @test test_Dimension_2D()
    @test test_AbsorptionMap()
end
