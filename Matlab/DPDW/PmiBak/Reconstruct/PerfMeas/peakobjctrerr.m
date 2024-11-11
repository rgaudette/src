%PEAKOBJCTRERR  Compute the centroid difference between largest objects.
%
%   err = peakobjctrerr(xtrue, xest, CompVol, Thresh)
%
%   err         The computed error for each estimate.
%
%   xtrue       The true object function.
%
%   xest        The estimates to analyze.
%
%   CompVol     The computational volume data structure.
%
%   Thresh      OPTIONAL: The threshold coefficient to label between non-zero
%               and zero valued voxels.  This value is multiplied by the peak
%               value in the object function to compute the threshold level
%               (default: 0.5).
%
%   PEAKOBJCTRERR
function err = peakobjctrerr(xtrue, xest, CompVol, Thresh)

nEst = size(xest, 2);
nDomain = [length(CompVol.Y) length(CompVol.X) length(CompVol.Z)];

%%
%%  Find the indices of the largest object in the true function.
%%
[xtrueidx truebin] = findbigobj(xtrue, nDomain, Thresh);
xtruezero = xtrue .* truebin;
ctr_true = objctr(xtruezero, CompVol, Thresh) * ones(1,nEst);

%%
%%  Find the centroids for the estimates
%%
ctr_est = zeros(3, nEst);
for i = 1:nEst
    [xestidx estbin] = findbigobj(xest(:,i), nDomain, Thresh);
    xestzero = xest(:,i) .* estbin;
    ctr_est(:,i) = objctr(xestzero, CompVol, Thresh);
end


err = sqrt(sum((ctr_true - ctr_est) .^2));

