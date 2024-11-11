%WAPPROX        Apprimate a signal with a wavelet transform.
%
%   [App w ScMap] = wapprox(x, hApp, hDet, Scales, flgLastApp)
%
%   App         The approximation to the sequence x. 
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
%   flgLastApp  [OPTIONAL]: If this parameter is non-zero then the last
%               scale included is the approximation sequence.  If this
%               parameter is zero then the approximation sequence is not
%               included in the reconstruction.
%
%   Calls: dwtp, idtwp
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:25 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: wapprox.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:25  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [App, w, ScMap] = wapprox(x, hApp, hDet, Scales, flgLastApp)

if nargin < 5
    flgLastApp = 1;
end

%%
%%  Compute the discrete wavelet transform of the sequence
%%
LastScale = max(Scales);
[w ScMap] = dwtp(x, hApp, hDet, LastScale);

%%
%%  Zero out the unselected scales
%%
nScale = length(ScMap);
Start = [1; cumsum(ScMap(1:nScale-1))+1];
Stop = cumsum(ScMap);

for iScale = 1:LastScale
    if(~any(iScale == Scales))
        nElems = Stop(iScale) - Start(iScale) + 1;
        w(Start(iScale):Stop(iScale)) = zeros(nElems,1);
    end
end

if ~flgLastApp
    nElems = Stop(nScale) - Start(nScale) + 1;
    w(Start(nScale):Stop(nScale)) = zeros(nElems,1);        
end

%%
%%  Reconstruct the signal from the remaining WT coefficients.
%%
App = idwtp(w, ScMap, hApp, hDet);
