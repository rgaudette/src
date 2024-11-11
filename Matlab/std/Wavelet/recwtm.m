%RECWTM         A recursive wavelet transform, mirroring the signal endpoints.
%
%   [w ScMap] = recwtm(x, hApp, hDet)
%
%   w           The WT coeffiecients.  The finest scale coeffiecients are first
%
%   ScMap       A vector containing the number of samples saved in the Detail
%               convolution and if this is the last stage, the number for the
%               the approximation convolution.
%
%   x	        The sequence to be tranformed (this function assumes x is a 
%               column vector).
%
%   hApp        The "Approximation" filter impulse response as row vector.
%
%   hDet        The "Detail" filter impulse response as row vector, in reverse
%               order.

function [w, sc] = recwtm(x, Approx, hDet, sc)

%%
%%  Initialization
%%

if nargin < 4,    
    sc = [];
end
hDet = hDet(:)';
hApp = hApp(:)';

%%
%%	Make sure signal is a column vector.
%%
x = x(:);

%%
%%	Find the length of the signal & filters
%%
lenX = length(x);
lenhDet = length(hDet);
lenhApp = length(hApp);

%%
%%	Mirror the ends of the signal to produce the same number of inner product
%%  points from the filter output as the input.
%%
beginX = flipud(x(1:lenhApp/2-1));
endX = flipud(x(lenX-(lenhApp/2):lenX));
x = [beginX ; x; endX];

%%
%%  Compute the "Detail" portion of the WT
%%
wd = filter(hDet, 1, x);

%%
%%  Use only the full inner product (steady state) samples from the convolution.
%%  Subsample by 2.
%%
wd = wd([lenhDet:2:length(wd)-2]);
sc = [sc length(wd)];

%%
%%  Compute "Approximation" of x at the current scale, 
%%  subsample, and send to next stage.
%%
wa = filter(hApp, 1, x);
wa = wa([lenhApp:2:length(wa)-2]);

%%
%%  If the approximation is shorter than the filter length we are done.
%%  Otherwise we can call this function again with the approximation
%%  as the new sequence.
%%
if length(wa) < lenhApp,    
    w = [wd; wa];    
    sc = [sc length(wa)];    
    return;
else    
    [wcoarse sc] = recwtm(wa, hApp, hDet, sc);
    w = [wd; wcoarse];
end
