using PyCall

img_scale = pyimport("image_scale")

r = rand(3, 4)
sf = 2.0

r2 = img_scale.scale(r, sf)
println("r2 shape ", string(size(r2)))
ratio = r2 ./ r

print(ratio)

cham = pyimport("iterative.tv_denoise_chambolle")

big = rand(256, 320)

den_big = cham.denoise_tv_chambolle_nd(big, weight = 0.2, n_iter_max= 3)
