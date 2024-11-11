%WFC_HAT        Hat Wavelet Transform Filter Coefficients.
%
%   [Approx Detail] = wfc_hat

function [Approx, Detail] = wfc_hat
Approx = [ 0.0667134544217 ...
           -.3511791236920 ...
           -.8532483337317 ...
           -.3710166034097 ...
           0.0794280881234 ...
           0.0150889459152 ];
Detail = (-1) .^ [0:5] .* fliplr(Approx);
