%WFC_D12        Daubechies D12 Wavelet Transform Filter Impulse Responses
%
%   [hApp hDet] = wfc_d12
%
%   WFC_D12 generates Daubechies D12 approximation and detail filter impulse
%   responses

function [hApp, hDet] = wfc_d12

hApp =[	.111540743350	.494623890398	.751133908021	...
        .315250351709	-.226264693965	-.129766867567	...
        .097501605587	.027522865530	-.031582039317	...
        .000553842201	.004777257511	-.001077301085	];

hDet = (-1) .^ [0:11] .* fliplr(hApp);

