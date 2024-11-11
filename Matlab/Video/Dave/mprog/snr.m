%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function takes the original signal along
% with its reconstructed version and computes the
% the average signal to noise ratio. 
%
%              sample var. of signal
%       snr =  ---------------------
%              sample var. of error
%  
% author: David Hoag
%
% function: snr.m   
%
% input: x    ==> original signal
%        xhat ==> reconstructed signal 
%        
% output: av_snr ==> average signal to noise ratio  
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function av_snr = snr(x,xhat);

dimension = size(x);
ysize = dimension(1);
xsize = dimension(2);

% Compute sample mean of original signal
x_mean = sum(sum(x))/(ysize*xsize);

% Compute sample variance of signal
x_var = sum(sum((x-x_mean).*(x-x_mean)))/(ysize*xsize-1);

% Compute error
error = x - xhat;

% Compute sample mean of the error
err_mean = sum(sum(error))/(ysize*xsize);

% Compute sample variance of error
err_var = sum(sum((error-err_mean).*(error-err_mean)))/(ysize*xsize-1);

av_snr = 10*log10((x_var/err_var));
