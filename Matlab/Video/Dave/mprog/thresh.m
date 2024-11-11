%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function takes the wavelet transformed
% image and replaces any coefficient whose
% absolute value is less than a preset threshold
% with zero, otherwise the coefficient is 
% unchanged.
%
% author: David Hoag
%
% function: thresh.m   
%
% input: img ==> input image
%        thresh ==> preset threshold 
%        
% output: comp_img ==> compressed image
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function comp_img = thresh(img,thres);

dimension = size(img);
ysize = dimension(1);
xsize = dimension(2);

% Allocate memory for the compressed image
comp_img = zeros(ysize,xsize);

for i=1:ysize;
    for j=1:xsize;
        if (abs(img(i,j)) > thres)
           comp_img(i,j) = img(i,j);
        end;
    end;
end;	 
