%DWTZ           Compute the discrete wavelet transform, ends are zero padded.
%
%   [w ScMap] = dwtz(x, hApp, hDet, nDecomp)
%
%   w           The WT coeffiecients.  The finest scale coeffiecients are
%               the first block of coefficients.
%
%   ScMap       A vector containing the number of samples saved in the detail
%               convolution and if this is the last stage, the number for the
%               the approximation convolution.
%
%   x	        The sequence to be transformed.
%
%   hApp        The approximation filter impulse response.
%
%   hDet        The detail filter impulse response.
%
%   nDecomp     [OPTIONAL] The number of decompositions to perform on the
%               sequence.  The length of the sequence must be divisible by 2
%               this many times.  The default value is a full decomposition.
%
%   DWTZ computes the discrete dyadic wavelet transform of the sequence x
%   using the approximation and detail filter impulse responses hApp and
%   hDet.  The ends of the original signal and the approximation sequences
%   are zero padded (either implicitly or explicitly) at each stage.  The
%   decomposition filters (hApp and hdet) are assumed to be the same length
%   in this algorithm.  If the decomposition filters are even length, the
%   first detail and approximation sequence value is when the signal is half
%   the length of the filter plus one into the filter.


function [w, sc] = dwtz(x, hApp, hDet, nDecomp)

%%
%%  Find largest possible number of decompositions
%%
nX = length(x);

kmax = 1;
a = nX / 2;
while a == floor(a),
    kmax = kmax + 1;
    a = a / 2;
end
kmax = kmax - 1;

if nargin < 4,
    nDecomp = kmax;
else
    if nDecomp > kmax,
        error('Number of decompositions is too great');
    end
end

%%
%%  Initialization, make sure x is a column vector, and the bases coefficients
%%  are reversed for use with filter.
%%
sc = zeros(nDecomp + 1, 1);
w = [];
nFilt = length(hApp);
nFiltBy2 = nFilt / 2;
hApp = hApp(:)';
hDet = hDet(:)';
x = x(:);

%%
%%  Perform the number of decompositions requested
%%
for k=1:nDecomp,

    %%
    %%	Zero pad the end of the sequence, with the filter function the 
    %%  beginning is implicitly zero padded.
    %%
    x = [x; zeros(floor(nFiltBy2),1)];

    %%
    %%  Compute the detail portion of the WT.  Using only the full inner
    %%  product (steady state) samples from the convolution.
    %%  Subsample by 2.
    %%
    wd = filter(hDet, 1, x);
    idxSub = floor(nFiltBy2)+1:2:length(wd);
    wd = wd(idxSub);
    w = [w; wd];
    sc(k) = length(wd);

    %%
    %%  Compute the approximation of x at the current scale, 
    %%  subsample, and send to next stage.
    %%
    x = filter(hApp, 1, x);
    x = x(idxSub);
end

%%
%%  Place the final approximation values into the coeffiecient matrix.
%%
w = [w; x];
sc(nDecomp+1) = length(x);
