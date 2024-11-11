%RECWT          Compute a Wavelet Transform using a recursive algorithm.
%
%   [w ScMap] = recwt(x, hApp, hDet)
%
%   w           The WT coefficients.  The coefficients for each scale are
%               organized according the vector ScMap.
%
%   ScMap       A vector containing the number of coefficients saved for each
%               scale.
%
%   x	        The sequence to be tranformed (this function assumes x is a 
%               column vector).
%
%   hApp        The "Approximation" filter impulse response as row vector.
%
%   hDet        The "Detail" filter impulse response as row vector, in reverse
%               order.
%
%       This routine computes a wavelet decomposition using the provided
%   scaling and approximation filters.  This routine does not perform any edge
%   processing
%
%       The approximation and scaling filters should be supplied as impulse
%   responses since this routine uses the FILTER function to perform an
%   efficient inner product computation.  The impulse response order is the
%   reverse of the basis function coefficients.
%
%       The coefficients are returned in a single stacked vector with the
%   finest scale being first.  The vector ScMap contains the number of
%   coefficients saved at each scale.
%
%   See also WT, RECWTM, RECWTP

function [w, ScaleMap] = recwt(x, hApp, hDet, ScaleMap)

%%
%%  Initialization
%%
if nargin < 4,
    ScaleMap = [];
end


%%
%%	Find the length of the signal & filters. Also place N-1 zeros at the end
%%  of the signal sequence, this causes filter to give the same resuls as conv.
%%
lenFilter = length(hApp);
x = [x; zeros(lenFilter-4,1)];
lenX = length(x);

%%
%%  Compute the "Detail" coefficients & subsample by 2.
%%
wd = filter(hDet, 1, x);
wd = wd([2:2:lenX]);
ScaleMap = [ScaleMap length(wd)];

%%
%%  Compute "Approximation" coefficients.
%%  subsample, and send to next stage.
%%
wa = filter(hApp, 1, x);
wa = wa([2:2:lenX]);

%%
%%  If the approximation is shorter than the filter length we are done.
%%  Otherwise we can call this function again with the approximation
%%  as the new sequence.
%%
if length(wa) < lenFilter,
    w = [wd; wa];
    ScaleMap = [ScaleMap length(wa)];
    return;

else
    [wcoarse ScaleMap] = recwt(wa, hApp, hDet, ScaleMap);
    w = [wd; wcoarse];
end

