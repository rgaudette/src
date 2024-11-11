%IDWTP          Inverse discrete wavelet transform using periodized coefficients.
%
%   [x] = idwtp(w, ScMap, hApp, hDet)
%
%   w           The WT coeffiecients.  The finest scale coeffiecients are first
%
%   ScMap       A vector containing the number of samples saved in the Datail
%               convolution and if this is the last stage, the number for the
%               the approximation convolution.
%
%   x	        The sequence to be tranformed.
%
%   hApp        The approximation filter impulse reponse coefficients.
%
%   hDet       The detail filter impulse reponse coefficients

function [x] = idwtp(w, ScMap, hApp, hDet)

%%
%%  Size the inpute vectors correctly
%%
w = w(:);
ScMap = ScMap(:)';


%%
%%	Find the length of the current wavelet scale and filters
%%
lenFilter = length(hApp);

%%
%%  Compute the indicies for each scale of the wavelet coefficients
%%
nScale = length(ScMap);
Start = [1 (cumsum(ScMap(1:nScale-1))+1)];
Stop = cumsum(ScMap);

%%
%%  Extract the coarse approximation
%%
approx = w(Start(nScale):Stop(nScale));

%%
%%  Working towards finer scales interpolate & filter both the approximation
%%  from the previous scale and the detail signal at this scale.
%%
for idxScale = nScale-1:-1:1,

    %%
    %%  Interpolate & periodize the approximation sequence.
    %%
    nApp = length(approx);
    intrpA = zeros(2*length(approx), 1);
    intrpA([1:2:2*nApp]) = approx;
    nIntrpA = length(intrpA);
    intrpA = [intrpA(nIntrpA-lenFilter+2:nIntrpA); intrpA];

    %%
    %%  Filter the interpolated seqeunce, using only the steady state values.
    %%
    approx = filter(rev(hApp), 1, intrpA);
    approx = approx(lenFilter:length(approx));
    
    %%
    %%  Interpolate & periodize the detail sequence.
    %%
    detail = w(Start(idxScale):Stop(idxScale));

    nDet = length(detail);
    intrpD = zeros(2*nDet, 1);
    intrpD([1:2:2*nDet]) = detail;
    nIntrpD = length(intrpD);
    intrpD = [intrpD(nIntrpD-lenFilter+2:nIntrpD); intrpD];

    %%
    %%  Filter the interpolated seqeunce, using only the steady state values.
    %%
    detail = filter(rev(hDet), 1, intrpD);
    detail = detail(lenFilter:length(detail));

%    if length(detail) < length(approx),
%        detail(length(approx)) = 0;
%    end
    
    %%
    %%  Sum them this becomes the new approximation for the next scale
    %%
    approx = approx + detail;
    
end
x = approx;

