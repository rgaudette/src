%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function performs the N-step biorthogonal wavelet 
% decomposition on a given input image.
%
% author: David Hoag
%
% input: image ==> input image
%            N ==> # of decompositions
%
% output: img ==> output image
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function img = bi_dec1(img,N);

img = bi_dec1(img);
subim = img;

for i=1:N-1;
    dim = size(subim);
    ysize = dim(1)/2;
    xsize = dim(2)/2;
    subim = img(1:ysize,1:xsize);
    subim = bi_dec1(subim);
    img(1:ysize,1:xsize) = subim;
end;
