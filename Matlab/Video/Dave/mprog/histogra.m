%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%
% This function takes an input image and generates
% a histogram of the pixel intensities.
%
%   function: histogram.m
%   
%   input: img ==> input image matrix
%          res ==> # of gray levels    
%
%   output: hist ==> vector containing histogram information 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function hist=histogram(img,res);

dimension = size(img);
ysize = dimension(1);
xsize = dimension(2);

x=zeros(1,res);

for i=1:ysize;
    for j=1:xsize;
        x(img(i,j)+1) = x(img(i,j)+1) + 1;
    end;
end;

hist=x;

bar(hist);
