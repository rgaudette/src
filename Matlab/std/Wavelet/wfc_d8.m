%WFC_D8         Daubechies D8 Wavelet Transform Filter Impulse Responses
%
%   [hApp hDet] = wfc_d8
%
%   WFC_D8 generates Daubechies D8 approximation and detail filter impulse
%   responses

function [hApp, hDet] = wfc_d8

hApp = [ 0.230377813309	 0.714846570553	...
         0.630880767930	-0.027983769417	...
        -0.187034811719	 0.030841381836	...
         0.032883011667	-0.010597401785	];

hDet = (-1) .^ [0:7] .* fliplr(hApp);

