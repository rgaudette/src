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
%   Thresh      The threshold to consider the voxel object or background.  This
%               is a scale factor mutlplied by the initial voxel's magnitude to
%               get a threshold value.
%
%   SELOBJCTRERR computes the difference of the centroids of the objects
%   present in xest compared to the object in xtrue.  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:39 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: selobjctrerr.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:39  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [err, binobjfct]= selobjctrerr(xtrue, xest, CompVol, idxInit, Thresh)

nVoxel = length(xtrue);
nEst = size(xest, 2);
if nargout > 1
    binobjfct = zeros(nVoxel, nEst);
end

nDomain = [length(CompVol.Y) length(CompVol.X) length(CompVol.Z)];
lidxInit = sub2ind(nDomain,  idxInit(1), idxInit(2), idxInit(3));
trueThresh = xtrue(lidxInit) * Thresh;

%%
%%  Find the indices of the true object
%%
[xtrueidx truebin] = findobject(xtrue, nDomain, idxInit, trueThresh);
xtruezero = xtrue .* truebin;
ctr_true = repmat(objctr(xtruezero, CompVol, Thresh), 1, nEst);

%%
%%  Find the centroids for the estimates
%%
ctr_est = zeros(3, nEst);
for i = 1:nEst,
    currThresh = xest(lidxInit, i) * Thresh
    if currThresh > 0
        [xestidx estbin] = findobject(xest(:,i), nDomain, idxInit, currThresh);
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
