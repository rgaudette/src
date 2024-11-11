using Interpolations
using BenchmarkTools

show_result = true
nr = 3
nc = 4
A = reshape(collect(1:(nr * nc)), nr, nc)
r = collect(1:nr)
c = collect(1:nc)
ri = collect(0.5:0.5:(nr + 0.5))
ci = collect(0.5:0.5:(nc + 0.5))

# Interpolation algorithms: BSpline or Gridded
# With BSpline we need a boundary condition for the higher order cases
# itp_gridded = interpolate((r, c), a, Gridded(Linear()))
# To estimate values outside of the original region we need ot Throw, Flat, Line, Periodic and Reflect

# Constant BSpline (nearest neighbor) with a Linear extrapolator
bspline_degree = Constant()
interpolation_algorithm = BSpline(bspline_degree)
itp_bspline_const = interpolate(A, interpolation_algorithm)
etp_bspline_const = extrapolate(itp_bspline_const, Line())

println("Constant BSpline with Line extrapolation")
@btime etp_bspline_const(ri, ci)
bspline_const_out = etp_bspline_const(ri, ci)
if show_result
    display(bspline_const_out)
end

# Linear BSpline (equivalent to bi-linear interpolation) with a Linear extrapolator
bspline_degree = Linear()
interpolation_algorithm = BSpline(bspline_degree)
itp_bspline_linear = interpolate(A, interpolation_algorithm)
etp_bspline_linear = extrapolate(itp_bspline_linear, Line())

println("linear BSpline with Line extrapolation")
@btime etp_bspline_linear(ri, ci)
bspline_linear_out = etp_bspline_linear(ri, ci)
if show_result
    display(bspline_linear_out)
end

# Quadratic BSpline with knots on the grid points, a Linear(Natural) boundary condition and a Linear extrapolator
knots = OnGrid()
boundary_condition = Line(knots)
bspline_degree = Quadratic(boundary_condition)

interpolation_algorithm = BSpline(bspline_degree)
itp_bspline_quad_line_on_grid = interpolate(A, interpolation_algorithm)
etp_bspline_quad_line_on_grid = extrapolate(itp_bspline_quad_line_on_grid, Line())

println("Quadratic line on grid BSpline with Line extrapolation")
@btime etp_bspline_quad_line_on_grid(ri, ci)
bspline_quad_line_on_grid_out = etp_bspline_quad_line_on_grid(ri, ci)
if show_result
    display(bspline_quad_line_on_grid_out)
end


# Cubic BSpline with knots on the grid points, a Linear(Natural) boundary condition and a Linear extrapolator
knots = OnGrid()
boundary_condition = Line(knots)
bspline_degree = Cubic(boundary_condition)

interpolation_algorithm = BSpline(bspline_degree)
itp_bspline_cubic_line_on_grid = interpolate(A, interpolation_algorithm)
etp_bspline_cubic_line_on_grid = extrapolate(itp_bspline_cubic_line_on_grid, Line())

println("Cubic line on grid BSpline with Line extrapolation")
@btime etp_bspline_cubic_line_on_grid(ri, ci)
bspline_cubic_line_on_grid_out = etp_bspline_cubic_line_on_grid(ri, ci)
if show_result
    display(bspline_cubic_line_on_grid_out)
end


# Cubic BSpline with knots on the half points, a Linear(Natural) boundary condition and a Linear extrapolator
knots = OnCell()
boundary_condition = Line(knots)
bspline_degree = Cubic(boundary_condition)

interpolation_algorithm = BSpline(bspline_degree)
itp_bspline_cubic_line_on_grid = interpolate(A, interpolation_algorithm)
etp_bspline_cubic_line_on_grid = extrapolate(itp_bspline_cubic_line_on_grid, Line())

println("Cubic line on cell BSpline with Line extrapolation")
@btime etp_bspline_cubic_line_on_grid(ri, ci)
bspline_cubic_line_on_grid_out = etp_bspline_cubic_line_on_grid(ri, ci)
if show_result
    display(bspline_cubic_line_on_grid_out)
end


# Gridded linear interpolator and a Linear extrapolator
interpolation_algorithm = Gridded(Linear())
itp_gridded_linear = interpolate((r, c), A, interpolation_algorithm)
etp_gridded_linear = extrapolate(itp_gridded_linear, Line())

println("Gridded linear with Line extrapolation")
@btime etp_gridded_linear(ri, ci)
gridded_linear_out = etp_gridded_linear(ri, ci)
if show_result
    display(gridded_linear_out)
end
