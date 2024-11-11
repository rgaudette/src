%Hlm3DScatPntJacNB  Jacobian iteration 3D Helmholtz scatterd field solver.
%
%   [PhiScat PhiInc nIter] = Hlm3D_PntJac(CompVol, del_ksq, ksqBkgnd, ...
%                               pSrc, pDet, maxDelta, nIterMax, Debug)
%
%   PhiScat     The scattered field at each detector.  This vector is structured
%               as a column vector with detectors being iterated over first
%               followed by the sources.
%
%   PhiInc      The incident response at each detector from each source in a
%               column vector.
%
%   CompVol     A structure defining the computational volume.  This
%               structure should have the members: Type, X, Y and Z.  Type
%               should be uniform specifying a uniform sampling volume of
%               voxels. X, Y and Z are vectors specifying the centers of the
%               voxels.
%
%   del_ksq     The perturbations of the square of the complex wavenumber
%               for the Helmholtz equation specified at each element in the
%               computational volume.
%
%   ksqBkgnd    The background squared complex wavenumber for the medium.
%
%   pSrc        The position of the source(s) in the form [sx sy sz].
%               Each row represents a different source.
%
%   ASrc        The amplitude of each source.
%
%   pDet        The position of the detector(s) in the form [sx sy sz].
%               Each row represents a different detector.
%
%   maxDelta    OPTIONAL: The convergence threshold.  The absolute
%               difference between the previous estimate and the current
%               estimate divided by the previous estimate should be less
%               then this value at all elements to flag convergence.
%
%   nIterMax    OPTIONAL: The maximum number of iteration to calculate
%               (default: 10000).
%
%   Debug       OPTIONAL: Print out debugging info.
%
%
%   Hlm3DScatPntJacNB computes the solution to the scattered field of a
%   free space Helmholtz equation with a heterogenous wavenumber parameter.
%   The solution is computed using Jacobi iterations.  The effective source
%   is computed by calculating the homogenous (or inicident) field response
%   at each inhomogeneity.
%
%
%   Bugs:  currently only handles boundaries on the Z-axis.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:33 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: Hlm3DScatPntJacZB.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:33  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [PhiScat, PhiInc, nIter] = Hlm3DScatPntJacZB(CompVol, del_ksq, ksqBkgnd, ...
    pSrc, ASrc, pDet, ADet, maxDelta, nIterMax, Debug)

if nargin < 10
    Debug = 0;
    if nargin < 9
        nIterMax = 10000;
        if nargin < 8
            maxDelta = 1e-2;
        end
    end
end

%%
%%  Make sure CompVol type is uniform and calculate size of domain
%%
if ~strcmp(CompVol.Type, 'uniform')
    error('This routine only works with uniform voxelations')
end
nX = length(CompVol.X); nY = length(CompVol.Y); nZ = length(CompVol.Z);
nSrc = size(pSrc, 1);
nDet = size(pDet, 1);
del_ksq = reshape(del_ksq, nY, nX, nZ);
ksq = ksqBkgnd + del_ksq;
kBkgnd = sqrt(ksqBkgnd);

%%
%%  Pre-allocate resulatant fields
%%
PhiScat = zeros(nDet, nSrc) + j * ones(nDet, nSrc);
PhiInc = zeros(nDet, nSrc) + j * ones(nDet, nSrc);

%%
%%  Calculate the stable step size
%%
dt = CompVol.XStep / 2 * CompVol.YStep / 2 * CompVol.ZStep / 2;
rx = dt / CompVol.XStep ^ 2;
ry = dt / CompVol.YStep ^ 2;
rz = dt / CompVol.ZStep ^ 2;

%%
%%  -1,0,+1 shift index vectors
%%
iXm1 = 1:nX-2; iX = iXm1+1; iXp1 = iX+1;
iYm1 = 1:nY-2; iY = iYm1+1; iYp1 = iY+1;
iZm1 = 1:nZ-2; iZ = iZm1+1; iZp1 = iZ+1;

%%
%%  Loop over each source position
%%
for iSrc = 1:nSrc
    if Debug
        fprintf('%d  ', iSrc);
    end

    %%
    %%  Compute the incident field throughout the medium.  Linearly
    %%  interpolate the incident field at each detector.  Source is
    %%  reflected about the z-boundary.
    %%
    [mX mY mZ] = meshgrid(CompVol.X - pSrc(iSrc, 1), ....
        CompVol.Y - pSrc(iSrc, 2), CompVol.Z - pSrc(iSrc, 3));
    r = sqrt(mX.^2 + mY.^2 + mZ.^2);

    PhiOld =  ASrc(iSrc) * exp(j * kBkgnd * r) ./ (-4 * pi * r) ;
    pSrcRefl = -1 * pSrc(iSrc, 3) + 2 * max(CompVol.Z);
    [mX mY mZ] = meshgrid(CompVol.X - pSrc(iSrc, 1), ....
        CompVol.Y - pSrc(iSrc, 2), CompVol.Z - pSrcRefl);
    r = sqrt(mX.^2 + mY.^2 + mZ.^2);
    PhiOld =  PhiOld - ASrc(iSrc) * exp(j * kBkgnd * r) ./ (-4 * pi * r) ;
    clear mX mY mZ r
    PhiInc(:, iSrc) = interpn(CompVol.Y, CompVol.X, CompVol.Z, PhiOld, ...
        pDet(:,2), pDet(:,1), pDet(:,3));


    %%
    %%  Create the effective source function
    %%
    EffSrc = -1 * PhiOld .* del_ksq;

    %%
    %%  Reset PhiOld and PhiNew to zeros
    %%
    PhiOld = zeros(nY, nX, nZ);
    PhiNew = PhiOld;
    %%
    %%  Compute the total field throughout the medium
    %%
    for nIter = 1:nIterMax
        PhiNew(iY,iY,iZ) =  ...
            ry * (PhiOld(iYm1,iX,iZ) + PhiOld(iYp1,iX,iZ)) + ...
            rx * (PhiOld(iY,iXm1,iZ) + PhiOld(iY,iXp1,iZ)) + ...
            rz * (PhiOld(iY,iX,iZm1) + PhiOld(iY,iX,iZp1)) + ...
            (1 - 2 * (ry + rx + rz) + dt * ksq(iY,iX,iZ)) .* PhiOld(iY,iX,iZ) ...
            - dt * EffSrc(iY,iX,iZ);

        iNZ = PhiOld ~= 0;
        del_Phi = abs((PhiNew(iNZ) - PhiOld(iNZ)) ./ PhiOld(iNZ));
        
        if max(del_Phi) < maxDelta;
            break;
        end
        PhiOld = PhiNew;
    end


    %%
    %%  Interpolate the field at the detector positions
    %%
    PhiScat(:, iSrc) = interpn(CompVol.Y, CompVol.X, CompVol.Z, PhiNew, ...
        pDet(:,2), pDet(:,1), pDet(:,3));
end
PhiScat = PhiScat(:);
PhiInc = PhiInc(:);
if Debug
    fprintf('\n');
end
