%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% author: David Hoag
%
% function: dilateIm.m   
%
% This function performs a dilation on a binary 
% image in order to add an outer layer of pixels 
% to all edgel information (pixels with value 0). Note
% that background pixels have value 255.
%
% For vertical edge detection the templates [255 0] and
% [0 255] are used. For horizontal edge detection the 
% templates [255 0]' and [0 255]' are used. 
% 
% input: inImg    ==> input binary image
%
% output: outImg ==> output binary Image  
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  outImg = dilateIm(inImg);

[ydim xdim] = size(inImg);

outImg = inImg;

% Dilate vertical edges. Detect [255 0] then [0 255].
idx = find(inImg(:,1:xdim-1)==255 & inImg(:,2:xdim)==0);
outImg(idx) = zeros(length(idx),1);

idx = find(inImg(:,1:xdim-1)==0 & inImg(:,2:xdim)==255)+ydim; 
outImg(idx) = zeros(length(idx),1);

% Erode horizontal edges by transposing the image then performing
% a dilation on the vertical edges. 
outImg = outImg';
idx = find(outImg(:,1:xdim-1)==255 & outImg(:,2:xdim)==0);
outImg(idx) = zeros(length(idx),1);

idx = find(outImg(:,1:xdim-1)==0 & outImg(:,2:xdim)==255)+ydim; 
outImg(idx) = zeros(length(idx),1);

% Transpose the image back
outImg = outImg';

