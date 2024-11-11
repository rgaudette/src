%HlmMEBornNB     Modified Ext. Born approximation of the Helmholtz Eq with no bnd.
%
%   [phi_scat phi_o] = HlmEBornNB(CompVol, k_o, del_k_sq, pSrc, pDet,Debug)
%
%   phi_scat    The scattered field at each detector.
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
%   del_k_sq    The perturbation to the squared background wavenumber.
%               There should be one element for element in the
%               computational volume.  The indexing order is Y, X, Z.
%
%   pSrc        The position of the source(s) in the form [sx sy sz].
%               Each row represents a different source.
%
%   pDet        The position of the detector(s) in the form [sx sy sz].
%               Each row represents a different detector.
%
%   Debug       OPTIONAL: Print out debugging info.
%
%
%   HlmEBornNB
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:32 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: HlmMEBornNB.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:32  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [phi_scat, phi_inc_det] = HlmMEBornNB(CompVol, k_o, del_k_sq, pSrc, pDet, Debug)

if nargin < 6
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
    r = sqrt((Xm - Det(1)).^2 + (Ym - Det(2)).^2 + (Zm - Det(3)).^2);
    Gscat = exp(j * k_o * r) ./ (-4 * pi * r) * volVoxel;
    ScatCoef(iDet) = (1 + Gscat.' * del_k_sq) ^ -1;
end

%%
%%  Loop over each source position
%%
phi_scat = zeros(nDet * nSrc, 1);
phi_inc_det = zeros(nDet * nSrc, 1);
for iSrc = 1:nSrc
    if Debug
        fprintf('%d  ', iSrc);
    end
    Src = pSrc(iSrc,:);

    %%
    %%  Compute the incident field at each detector from the free space Green's
    %%  function.
    %%
    rsd = sqrt((pDet(:,1) - Src(1)).^2 + (pDet(:,2) - Src(2)).^2 + ...
        (pDet(:,3) - Src(3)).^2);
    idxBlk = [((iSrc-1) * nDet + 1):iSrc*nDet];
    phi_inc_det(idxBlk) = exp(j * k_o * rsd) ./ (-4 * pi * rsd);

    %%
    %%  Compute the incident response on every voxel for the current source.
    %%  The source is represented by a point source.
    %%
    r = sqrt((Xm - Src(1)).^2 + (Ym - Src(2)).^2 + (Zm - Src(3)).^2);
    phi_o = exp(j * k_o * r) ./ (-4 * pi * r);

    %%
    %%  Compute the
    %%
    for iDet = 1:nDet
        Det = pDet(iDet,:);
        %%
        %%  Compute the scattered response at this detector from all
        %%  of the voxels.
        %%
        r = sqrt((Xm - Det(1)).^ 2 + (Ym - Det(2)).^2 + (Zm - Det(3)).^2);
        Gscat = exp(j * k_o * r) ./ (-4 * pi * r) * volVoxel;
        phi_scat((iSrc-1)*nDet + iDet) = -ScatCoef(iDet) * Gscat.' * ...
            (del_k_sq .* phi_o);
        
    end

end

if Debug
    fprintf('\n');
end
