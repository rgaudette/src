%maskedXcorr2   Cross correlate 2 images over the specified search radius


function [ccc, shift] = maskedXcorr2(im1, im2, searchRadius)


% Get the image size and create the image mask
szIm1 = size(im1);
szIm2 = size(im2);

center = floor(szIm2 / 2) + 1

% TODO: should Y be flipped?
[idxIm2y idxIm2x] = ndgrid([1:szIm2(2)] - center(2), ...
                           [1:szIm2(1)] - center(1))

szImageMask = szIm2 ./ 2 - searchRadius

imageMask =  (abs(idxIm2y) <= szImageMask(1)) & (abs(idxIm2x) <= szImageMask(2))
