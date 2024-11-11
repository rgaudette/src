%WFC_D6         Daubechies D6 Wavelet Transform Filter Impulse Responses
%
%   [hApp hDet] = wfc_d6
%
%   WFC_D6 generates Daubechies D6 approximation and detail filter impulse
%   responses

function [hApp, hDet] = wfc_d6

hApp = [ 0.332670552950	 0.806891509311	...
         0.459877502118	-0.135011020010	...
        -0.085441273882	 0.035226291882	];

hDet = (-1) .^ [0:5] .* fliplr(hApp);

