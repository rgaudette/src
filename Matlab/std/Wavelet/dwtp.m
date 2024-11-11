%DWTP           Compute the discrete wavelet transform, periodizing the signal.
%
%   [w ScMap] = dwtp(x, hApp, hDet, nDecomp)
%
%   w           The WT coeffiecients.  The finest scale coeffiecients are
%               the first block of coefficients.
%
%   ScMap       A vector containing the number of samples saved in the Datail
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


%   NEED TO PREALLOCATE MEMORY TO IMPROVE SPEED

function [w, sc] = dwtp(x, hApp, hDet, nDecomp)

%%
%%  Find largest possible number of decompositions
%%
nX = length(x);

kmax = 0;
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
x = x(:);
hApp = hApp(:)';
hDet = hDet(:)';
nFilt = length(hApp);
sc = [];
w = [];

%%
%%  Perform the number of decompositions requested
%%
for k=1:nDecomp,

    %%
    %%	Periodize the signal by copying a piece of the beginning of the sequence
    %%  to the end of the sequence.
    %%
    x = [x; x(1:nFilt-1)];

    %%
    %%  Compute the detail portion of the WT.  Using only the full inner
    %%  product (steady state) samples from the convolution.
    %%  Subsample by 2.
    %%
    wd = filter(hDet, 1, x);
    wd = wd([nFilt:2:length(wd)]);
    w = [w; wd];
    sc = [sc; length(wd)];

    %%
    %%  Compute the approximation of x at the current scale, 
    %%  subsample, and send to next stage.
    %%
    x = filter(hApp, 1, x);
    x = x([nFilt:2:length(x)]);
end

%%
%%  Place the final approximation values into the coeffiecient matrix.
%%
w = [w; x];
sc = [sc; length(x)];
