%DEPTHERR       Calculate error as a function of depth.
%
%   [err depth] = deptherr(xtrue, xest, CompVol)
%
%   err         Error as a function of depth.  Each column corresponds to
%               a different estimate in xest.  Each row is a different depth
%               specified by depth.
%
%   depth       The depth of each plane, this is just CompVol.Z.
%   
%   xtrue       The true value of the object function as column vector.
%
%   xest        The estimates to evaluate each estimate in its own column.
%
%   DEPTHERR computes error as a function of depth.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:08 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: deptherr.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:08  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [err, depth] = deptherr(xtrue, xest, CompVol)


nX = length(CompVol.X);
nY = length(CompVol.Y);
nZ = length(CompVol.Z);

xtrue = reshape(xtrue, nX, nY, nZ);
XPlaneNorm = zeros(nZ,1);
for i = 1:nZ
    XPlaneNorm(i) = norm(reshape(xtrue(:,:,i),nX*nY,1));
end
nEst = size(xest, 2);
err = zeros(nZ, nEst);

for i = 1:nEst
    ThisEst = reshape(xest(:,i), nX, nY, nZ);
    Diff = xtrue - ThisEst;
    
    for j = 1:nZ
        err(j, i) = norm(reshape(Diff(:,:,j), nX*nY, 1));
    end
end
