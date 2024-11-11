%WFC_D4         Daubechies D4 Wavelet Transform Filter Impulse Responses
%
%   [hApp hDet] = wfc_d4
%
%   WFC_D4 generates Daubechies D4 approximation and detail filter impulse
%   responses

function [hApp, hDet] = wfc_d4

hApp = 1/sqrt(2) * 0.25 * [1+sqrt(3) 3+sqrt(3) 3-sqrt(3) 1-sqrt(3)];

hDet = (-1) .^ [0:3] .* fliplr(hApp);

