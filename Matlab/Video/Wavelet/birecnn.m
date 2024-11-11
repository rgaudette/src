%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This program takes an N-step biorthogonal wavelet 
% decomposed image and reconstructs it.
%
%   author: David Hoag
%
%   input: img ==> decomposed input image
%            N ==> # of iterations for reconstruction
% 
%   output: img ==> reconstructed image
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function img = bi_reconstN(img,N);

dim = size(img);
ysize = dim(1)/(2^(N-1));
xsize = dim(2)/(2^(N-1));

for i=1:N;
    img(1:ysize,1:xsize)=birecn1(img(1:ysize,1:xsize));
    xsize = xsize*2;
    ysize = ysize*2;
end;
