%NORMALIZE      Normalize a matrix by removing the mean and standard deviation
%
%   [norm_x x_mean x_stdev] = normalize(x)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function takes the input matrix and
% normalizes it as (x-x_mean)/x_stdev. 
%
% author: David Hoag
%
% function: normalize.m   
%
% input: x ==> input matrix 
%        
% output: norm_x ==> normalized matrix 
%
%
% Modified:
%   rjg     95/07/17
%   - returns mean and standard deviation now.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [norm_x, x_mean, x_stdev] = normalize(x);

dimension = size(x);
ysize = dimension(1);
xsize = dimension(2);

% Compute sample mean
x_mean = mean(mean(x));

% Compute sample variance
x_var = sum(sum((x-x_mean).*(x-x_mean)))/(ysize*xsize-1);
x_stdev = sqrt(x_var);

% Normalize data
norm_x = (x-x_mean)/x_stdev;
