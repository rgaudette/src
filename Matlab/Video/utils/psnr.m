%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function takes the original signal along
% with its reconstructed version and computes the
% the peak signal to noise ratio. 
%
%              (peak-peak value of orig. signal)^2 
%      psnr =  -----------------------------------
%                    sample var. of error
%  
% author: David Hoag
%
% function: new_psnr.m   
%
% input: x    ==> original signal
%        xhat ==> reconstructed signal 
%        
% output: av_snr ==> average signal to noise ratio  
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function av_snr = new_psnr(x,xhat);

dimension = size(x);
ysize = dimension(1);
xsize = dimension(2);

% Compute peak-peak value squared
x_var = (255)^2; 

% Compute error
error = x - xhat;

% Compute sample mean of the error
err_mean = sum(sum(error))/(ysize*xsize);

% Compute sample variance of error
err_var = sum(sum((error-err_mean).*(error-err_mean)))/(ysize*xsize-1);

av_snr = 10*log10((x_var/err_var));
