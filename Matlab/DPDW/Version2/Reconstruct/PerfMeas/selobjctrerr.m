%SELOBJCTRERR   Compute the centroid difference between selected objects.
%
%   [err binobjfct] = selobjctrerr(xtrue, xest, CompVol, idxInit, Thresh)
%
%   err         The computed error for each estimate.
%
%   binobjfct   The binary object functions detected for each estimate.
%
%   xtrue       The true object function.
%
%   xest        The estimates to analyze.
%
%   CompVol     The computational volume data structure.
%
%   idxInit     The initial position to start the search for the object.
%               This is a vector of the form [idxX idxY idxZ]
%
%   Thresh      The threshold to consider the voxel object or background.
%
%   SELOBJCTRERR computes the difference of the centroids of the objects
%   present in xest compared to the object in xtrue.  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:09 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: selobjctrerr.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:09  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [err, binobjfct]= selobjctrerr(xtrue, xest, CompVol, idxStart, Thresh)

nVoxel = length(xtrue);
nEst = size(xest, 2);
if nargout > 1
    binobjfct = zeros(nVoxel, nEst);
end

nDomain = [length(CompVol.X) length(CompVol.Y) length(CompVol.Z)];

%%
%%  Find the indices of the true object
%%
[xtrueidx truebin] = findobject(xtrue, nDomain, idxStart, Thresh);
xtruezero = xtrue .* truebin;
ctr_true = repmat(objctr(xtruezero, CompVol, Thresh), 1, nEst);

ctr_est = zeros(3, nEst);
idx = sub2ind(nDomain, idxStart(1), idxStart(2), idxStart(3));
for i = 1:nEst,
    if xest(idx, i) > Thresh
        [xestidx estbin] = findobject(xest(:,i), nDomain, idxStart, Thresh);
        if nargout > 1
            binobjfct(:,i) = estbin;
        end
        xestzero = xest(:,i) .* estbin;
        ctr_est(:,i) = objctr(xestzero, CompVol, Thresh);
    else
        ctr_est(:,i) = NaN;
    end
    
end


err = sqrt(sum((ctr_true - ctr_est) .^2));
