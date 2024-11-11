%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function performs the N-step wavelet decomposition
% on a given input image.
%
% author: David Hoag
%
% input: image ==> input image
%            N ==> # of decompositions
%
% output: img ==> output image
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function img = decompN(img,N);

img = decomp1(img);
subim = img;

for i=1:N-1;
    dim = size(subim);
    ysize = dim(1)/2;
    xsize = dim(2)/2;
    subim = img(1:ysize,1:xsize);
    subim = decomp1(subim);
    img(1:ysize,1:xsize) = subim;
end;
