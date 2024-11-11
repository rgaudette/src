%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function takes the input matrix and
% calculates its standard deviation. 
%
% author: David Hoag
%
% function: stdev.m   
%
% input: x ==> input matrix 
%        
% output: stdev_x ==> standard deviation 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function stdev_x = stdev(x);

dimension = size(x);
ysize = dimension(1);
xsize = dimension(2);

% Compute sample mean
x_mean = mean(mean(x));

% Compute sample variance
x_var = sum(sum((x-x_mean).*(x-x_mean)))/(ysize*xsize-1);
stdev_x = sqrt(x_var);

