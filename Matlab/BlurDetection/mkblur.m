%mkblur   Create a motion blured image

function [blured, reference] = mkblur(im, outSize, step, npics)

imSize = size(im);
xStart = floor((imSize(2) - outSize(2))/2)
yStart = floor((imSize(1) - outSize(1))/2)
idxY = yStart:yStart+outSize(1)-1;
idxX = xStart:yStart+outSize(2)-1;
reference = im(idxY, idxX);
blured = reference;
for i=1:npics
  idxY = idxY + step(1);
  idxX = idxX + step(2);
  blured = blured + im(idxY, idxX);
end

blured = blured ./ npics;
