%SURFERR        Surface error
%
%   err = surferr(xest, CompVol, idxDepth)
%
%   err         The mean square value of the depths selected.
%
%   CompVol     The Computational Volume structure.
%
%   idxDepth    The depth to examine, 1 is the shallowest, n is the deepest.
%
%
%   SURFERR computes the mean square value of the depths selected.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:09 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: surferr.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:09  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function err = surferr(xest, CompVol, idxDepth)

[nVoxels nEst] = size(xest);
nX = length(CompVol.X);
nY = length(CompVol.Y);
nZ = length(CompVol.Z);

idxPlane = nZ - idxDepth + 1;
err = zeros(nEst, 1);
for i = 1:nEst
    tmp = reshape(xest(:,i), nX, nY, nZ);
    tmp = tmp(:,:,idxPlane);
    err(i) = mean(tmp(:) .^ 2);
end
