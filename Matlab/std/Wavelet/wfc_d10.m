%WFC_D10        Daubechies D10 Wavelet Transform Filter Impulse Responses
%
%   [hApp hDet] = wfc_d10
%
%   WFC_D10 generates Daubechies D10 approximation and detail filter impulse
%   responses

function [hApp, hDet] = wfc_d10

hApp = [.160102397974	.603829269797	.724308528438	...
        .138428145901	-.242294887066	-.032244869585	...
        .077571493840	-.006241490213	-.012580751999	...
        .003335725285									];
        
hDet = (-1) .^ [0:9] .* fliplr(hApp);

