%RECWTP         Compute a recursive wavelet transform, periodizing the signal.
%
%   [w ScMap] = recwtp(x, hApp, hDet)
%
%   w           The WT coeffiecients.  The finest scale coeffiecients are first
%
%   ScMap       A vector containing the number of samples saved in the Datail
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

function [w, sc] = recwtp(x, hApp, hDet, sc)

%%
%%  Initialization
%%

if nargin < 4,
    sc = [];
end

%%
%%	Find the length of the signal & filters
%%
lenX = length(x);
lenFilt = length(hApp);

%%
%%	Periodize the signal by copying a piece of the beginning of the sequence
%%  to the end of the sequence.
%%
x = [x; x(1:lenFilt-1)];

%%
%%  Compute the "detail" portion of the WT
%%
wd = filter(hDet, 1, x);

%%
%%  Use only the full inner product (steady state) samples from the convolution.
%%  Subsample by 2.
%%
wd = wd([lenFilt:2:length(wd)]);
sc = [sc length(wd)];

%%
%%  Compute "Approximation" of x at the current scale, 
%%  subsample, and send to next stage.
%%
wa = filter(hApp, 1, x);
wa = wa([lenFilt:2:length(wa)]);

%%
%%  If the approximation is shorter than the filter length we are done.
%%  Otherwise we can call this function again with the approximation
%%  as the new sequence.
%%

if length(wa) < lenFilt,    
    w = [wd; wa];    
    sc = [sc length(wa)];    
    return;
else    
    [wcoarse sc] = recwtp(wa, hApp, hDet, sc);
    w = [wd; wcoarse];
end

