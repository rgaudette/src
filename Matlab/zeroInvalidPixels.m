%zeroInvalidPixels

function im = zeroInvalidPixels(im, valid)
im(~ valid) = 0;
