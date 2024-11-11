%WFC_D14        Daubechies D14 Wavelet Transform Filter Impulse Responses
%
%   [hApp hDet] = wfc_d14
%
%   WFC_D14 generates Daubechies D14 approximation and detail filter impulse
%   responses

function [hApp, hDet] = wfc_d14

hApp = [	.077852054085	.396539319482	.729132090846	...
        .469782287405	-.143906003929	-.224036184994	...
        .071309219267	.080612609151	-.038029936935	...
        -.016574541631	.012550998556	.000429577973	...
        -.001801640704	.000353713800					]

hDet = (-1) .^ [0:11] .* fliplr(hApp);

