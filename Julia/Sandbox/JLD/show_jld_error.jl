using JLD
using SparseArrays

using IRWGeometry
using IRWScene
using IRWUtilities
r = Rectangle(1, 1, 0, 0)


# Config from
detector_pixel_size = 0.100
magnification = detector_pixel_size / 0.011
source_to_detector_dist = 250.760
reconstruction_region_voxel_width = 0.01
reconstruction_region_voxel_height = 0.01
# Use a rectangular reconstruction region to detect any n_x and n_y errors
reconstruction_region_width = 159 * reconstruction_region_voxel_width
reconstruction_region_height = 127 * reconstruction_region_voxel_height

# Code from  IRWForward2D

# Define the location of the region of interest relative to the center of the source positions (the origin)
volume_center_y = source_to_detector_dist / magnification
@info "Source to volume center distance: $volume_center_y"

# Region of interest structures
reconstruction_region_rect = Rectangle(
    1.0 * reconstruction_region_width / 2.0,
    volume_center_y - reconstruction_region_height / 2.0,
    reconstruction_region_width,
    reconstruction_region_height,
)


@debug "Reconstruction region rectangle: $reconstruction_region_rect"
# Create and fill the absorption map with the specified absorbers
# TODO: code style: need to figure how the AbsorptionMap object can take a immutable Rectangle
mrrr = MRectangle(
    reconstruction_region_rect.origin.x,
    reconstruction_region_rect.origin.y,
    reconstruction_region_rect.width,
    reconstruction_region_rect.height,
)

reconstruction_region_voxel_size = Dimension2D(reconstruction_region_voxel_width, reconstruction_region_voxel_height)

absorption_map = AbsorptionMap(mrrr, reconstruction_region_voxel_size)

# If the DSP module is loaded JLD crashes on the following write
#using DSP

jldopen("show_jld_error.jld", "w") do file
    addrequire(file, IRWGeometry)
    addrequire(file, IRWScene)
    addrequire(file, SparseArrays)
    write(file, "version_string", "1.0.0")
    write(file, "absorption_map", absorption_map)
end

# Validate that the output file can be read
output_dict = load("show_jld_error.jld")




# Does not crash with all using statements commented out
# using LinearAlgebra
# using Logging
# using Printf
# using Random
# using SparseArrays
# using Statistics


# @time using DataStructures
# Does not crash with the using statement in the block above executed

# Does crash with the using statements in the block above executed
# @time using Interpolations
# @time using IterativeSolvers
# Does crash with the using statements in the block above executed
# @time using JLD
# Does crash with the using statements in the block above executed
# @time using Krylov
# @time using KrylovMethods
# @time using OSQP
# @time using PyCall
# @time using PyPlot
# Does not crash with all using statements above commented out
# Does crash with the using statements in the block above executed

# using IRWForward2D
# using IRWGeometry
# using IRWScene
# using IRWMetrics
# using IRWUtilities

jldopen("show_jld_error.jld", "w") do file
    addrequire(file, IRWGeometry)
    addrequire(file, IRWScene)
    addrequire(file, SparseArrays)
    write(file, "version_string", "1.0.0")
    write(file, "absorption_map", absorption_map)
end