%IWT            Compute an inverse wavelet transform.
%
%   [x] = iwt(w, ScMap, fltApprox, fltDetail)
%

function [x] = iwt2(w, ScMap, fltApprox, fltDetail)


%%
%%	Find the length of the current wavelet scale and filters
%%
lenFilter = length(fltApprox);

%%
%%  Compute the indicies for each scale of the wavelet coefficients
%%
nScale = length(ScMap);
Start = [1 (cumsum(ScMap(1:nScale-1))+1)];
Stop = cumsum(ScMap);

%%
%%  Extract the coarse approximation
%%
prev_approx = w(Start(nScale):Stop(nScale));

%%
%%  Working towards finer scales interpolate & filter both the approximation
%%  from the previous scale and the detail signal at this scale.
%%
for idxScale = nScale-1:-1:1,

    %%
    %%  Interpolate & filter the approximation
    %%
    lenPA = length(prev_approx);
    intrpA = zeros(2*lenPA,1);
    intrpA([1:2:2*lenPA],1) = prev_approx
    prev_approx = filter(fltApprox, 1, [intrpA; zeros(lenFilter-1,1)])
    
    %%
    %%  Interpolate & filter the detail
    %%
    detail = w(Start(idxScale):Stop(idxScale));

    lenDet = length(detail);
    intrpD = zeros(2*lenDet, 1);
    intrpD([1:2:2*lenDet], 1) = detail

    detail = filter(fltDetail, 1, [intrpD; zeros(lenFilter-1,1)])
    if length(detail) < length(prev_approx),
        detail(length(prev_approx)) = 0;
    end
    
    %%
    %%  Sum them this becomes the new approximation for the next scale
    %%
    prev_approx = prev_approx + detail;
    
end
x = prev_approx;

