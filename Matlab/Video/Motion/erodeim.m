%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% author: David Hoag
%
% function: erodeIm.m   
%
% This function performs an erosion on a binary 
% image in order to remove the outer layer of pixels 
% associated with edgels (pixels with value 0). Note
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
function  outImg = erodeIm(inImg);

[ydim xdim] = size(inImg);

outImg = inImg;

% Erode vertical edges. Detect [255 0] then [0 255].
idx = find(inImg(:,1:xdim-1)==255 & inImg(:,2:xdim)==0)+ydim;
outImg(idx) = 255*ones(length(idx),1);

idx = find(inImg(:,1:xdim-1)==0 & inImg(:,2:xdim)==255); 
outImg(idx) = 255*ones(length(idx),1);

% Erode horizontal edges by transposing the image then performing
% an erosion on the vertical edges. 
outImg = outImg';

idx = find(outImg(:,1:ydim-1)==255 & outImg(:,2:ydim)==0)+xdim;
outImg(idx) = 255*ones(length(idx),1);

idx = find(outImg(:,1:ydim-1)==0 & outImg(:,2:ydim)==255); 
outImg(idx) = 255*ones(length(idx),1);
 
% Transpose the image back
outImg = outImg';
