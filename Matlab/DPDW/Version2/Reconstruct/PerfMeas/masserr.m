%MASSERR        Compute the mass difference between selected objects.
%
%   [err binobjfct] = masserr(xtrue, xest, CompVol, idxInit, Thresh)
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
%   MASSERR computes the difference of the masses of the objects
%   present in xest compared to the object in xtrue.  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:09 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: masserr.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:09  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [err, binobjfct]= massrr(xtrue, xest, CompVol, idxStart, Thresh)

nVoxel = length(xtrue);
nEst = size(xest, 2);
if nargout > 1
    binobjfct = zeros(nVoxel, nEst);
end

nDomain = [length(CompVol.X) length(CompVol.Y) length(CompVol.Z)];
VolVoxel = (CompVol.X(2) - CompVol.X(1)) * (CompVol.Y(2) - CompVol.Y(1)) * ...
    (CompVol.Z(2) - CompVol.Z(1));

%%
%%  Find the indices of the true object
%%
[xtrueidx truebin] = findobject(xtrue, nDomain, idxStart, Thresh);
mass_true = sum(xtrue .* truebin) * VolVoxel;

mass_est = zeros(1, nEst);
idx = sub2ind(nDomain, idxStart(1), idxStart(2), idxStart(3));
for i = 1:nEst,
    if xest(idx, i) > Thresh
        [xestidx estbin] = findobject(xest(:,i), nDomain, idxStart, Thresh);
        if nargout > 1
            binobjfct(:,i) = estbin;
        end
        mass_est(:,i) = sum(xest(:,i) .* estbin) * VolVoxel;
    else
        mass_est(:,i) = 0;
    end
    
end


err = mass_true - mass_est;
