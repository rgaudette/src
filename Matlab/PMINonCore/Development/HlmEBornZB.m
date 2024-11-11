%HlmEBornZB     Extended Born approximation of the Helmholtz Eq with zero bnd.
%
%   [phi phi_o] = HlmEBornZB(CompVol, k_o, del_k, pSrc, pDet, zBnd, Debug)
%
%   phi         The resultant field at each detector.
%
%   phi_o       The background expected from the homogenous medium k_o.
%
%   CompVol     A structure defining the computational volume.  This
%               structure should have the members: Type, X, Y and Z.  Type
%               should be uniform specifying a uniform sampling volume of
%               voxels. X, Y and Z are vectors specifying the centers of the
%               voxels.
%
%   k_o         The complex wavenumber for the Helmholtz equation for the
%               background medium.
%
%   del_k       The perturbation to the background wavenumber.  There should be
%               one element for element in the computational volume.  The
%               indexing order is Y, X, Z.
%
%   pSrc        The position of the source(s) in the form [sx sy sz].
%               Each row represents a different source.
%
%   pDet        The position of the detector(s) in the form [sx sy sz].
%               Each row represents a different detector.
%
%   zBnd        The position of the zero value boundary (Dirichlet
%               conditions).
%
%   Debug       OPTIONAL: Print out debugging info.
%
%
%   HlmEBornZB
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:27:27 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: HlmEBornZB.m,v $
%  Revision 1.1.1.1  2004/01/03 08:27:27  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [phi, phi_o] = HlmEBornZB(CompVol, k_o, del_k, pSrc, pDet, zBnd, Debug)

if nargin < 7
    Debug = 0;
end

nSrc = size(pSrc, 1);
nDet = size(pDet, 1);

%%
%%  Create the sampling volume
%%
if strcmp(CompVol.Type, 'uniform') == 0
    error('This routine only handles uniform voxelations');
end
[Xm Ym Zm] = meshgrid(CompVol.X, CompVol.Y, CompVol.Z);
Xm = Xm(:);
Ym = Ym(:);
Zm = Zm(:);
nPts = length(Xm);

%%
%%  Compute the Green's function from each voxel to each detector for the
%%  inverse term.  Torres-Verdin and Habahashy called this the scattering
%%  tensor, so in our case it is a scattering coefficient.
%%
ScatCoef = zeros(nDet, 1);
volVoxel = (CompVol.XStep * CompVol.YStep * CompVol.ZStep);
for iDet = 1:nDet
    Det = pDet(iDet, :);
    %%
    %%  Compute the free space Green's fct. from the voxel to the detector
    %%
    rho_sq = (Xm - Det(1)).^2 + (Ym - Det(2)).^2;
    r = sqrt(rho_sq + (Zm - Det(3)).^2);
    Gscat = exp(i * k_o * r) ./ (-4 * pi * r) * volVoxel;

    %%
    %%  Add in the image of the voxel
    %%
    r = sqrt(rho_sq + (Zm - (2 *zBnd - Det(3))).^2);
    Gscat = Gscat - exp(i * k_o * r) ./ (-4 * pi * r) * volVoxel;
    ScatCoef(iDet) = (1 - Gscat' * del_k) ^ -1;
end

%%
%%  Loop over each source position
%%
phi = zeros(nDet * nSrc, 1);
phi_o = zeros(nDet * nSrc, 1);
for iSrc = 1:nSrc
    if Debug
        fprintf('%d  ', iSrc);
    end

    %%
    %%  Compute the incident field at each detector from the half space Green's
    %%  function.
    %%
    Src = pSrc(iSrc,:);

    rho_sq = (pDet(:,1) - Src(1)).^2 + (pDet(:,2) - Src(2)).^2;
    rtrue = sqrt(rho_sq + (pDet(:,3) - Src(3)).^2);
    idxBlk = [((iSrc-1) * nDet + 1):iSrc*nDet];
    phi_o(idxBlk) = exp(j * k_o * rtrue) ./ (-4 * pi * rtrue);

    %%
    %%  Add in the image source due to the boundary
    %%
    rimag = sqrt(rho_sq + (pDet(:,3) - (2 * zBnd - Src(3))).^2);
    phi_o(idxBlk) = phi_o(idxBlk) - exp(j * k_o * rimag) ./ (-4 * pi * rimag) ;
    phi(idxBlk) = ScatCoef .* phi_o(idxBlk);
end
   
if Debug
    fprintf('\n');
end
keyboard