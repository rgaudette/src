%HLM3PTBORN1ZB  Nth Born approx. of a perturbed Helmholtz equation, z boundary.
%
%   [PhiScat Phi_Inc] = hlm3ptbornNzb(CompVol, k, dk, pSrc, pDet, zBnd)
%
%   Phi_Scat    The scattered response at each detector from each source in
%               a column vector.  The structure of the vector is the response
%               at each detector from the first source followed by the
%               response at each detector from the second source and so on.
%
%   Phi_Inc     The incident response at each detector from each source in a
%               column vector.  The same combination pattern as Phi_Scat.
%
%   CompVol     A structure defining the computational volume.  This
%               structure should have the members: Type, X, Y and Z.  Type
%               should be uniform specifying a uniform sampling volume of
%               voxels. X, Y and Z are vectors specifying the centers of the
%               voxels.
%
%   k           The complex wavenumber for the Helmholtz equation.
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
%
%   Do not specify the sources or detector exactly at a sampling point to
%   prevent dived by zero errors when evaluating the Green's functions.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:27:27 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: hlm3ptbornNzb.m,v $
%  Revision 1.1.1.1  2004/01/03 08:27:27  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [A, Phi_Inc] = hlm3ptbornNzb(CompVol, k, dk, pSrc, pDet, zBnd)

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
%%  A is created transposed for better caching performance
%%
A = zeros(nPts, nSrc*nDet) + j * ones(nPts, nSrc*nDet);
Phi_Inc = zeros(nSrc*nDet, 1) + j * ones(nSrc*nDet, 1);

%%
%%  Loop over each source detector combination
%%
fprintf('Src: ');
for iSrc = 1:nSrc
    fprintf('%d  ', iSrc);
    Src = pSrc(iSrc,:);

    %%
    %%  Compute the incident response on every voxel from each source.
    %%  The source is represented by a point source.
    %%
    rho_sq = (Xm - Src(1)).^2 + (Ym - Src(2)).^2;
    r = sqrt(rho_sq + (Zm - Src(3)).^2);
    phi_inc = exp(j * k * r) ./ (-4 * pi * r);
              
    
    %%
    %%  Add in the image source due to the boundary
    %%
    r = sqrt(rho_sq + (Zm - (2 * zBnd - Src(3))).^2);
    phi_inc = phi_inc - exp(j * k * r) ./ (-4 * pi * r) ;

    for iDet = 1:nDet
        Det = pDet(iDet,:);
        iCol = iDet + (iSrc-1) * nDet;
        
        %%
        %%  Compute the incident response at this detector  from all
        %%  of the voxels.  Note that the negative sign in the Green's function
        %%  is cancelled by the negative sign in the Born approximation
        %%
        rho_sq = (Xm - Det(1)).^2 + (Ym - Det(2)).^2;
        r = sqrt(rho_sq + (Zm - Det(3)).^2);
        Gscat = exp(i * k * r) ./ (4 * pi * r) * ...
            (CompVol.XStep * CompVol.YStep * CompVol.ZStep);

        %%
        %%  Add in the image of the voxel
        %%
        r = sqrt(rho_sq + (Zm - (2 *zBnd - Det(3))).^2);
        Gscat = Gscat - exp(i * k * r) ./ (4 * pi * r) * ...
            (CompVol.XStep * CompVol.YStep * CompVol.ZStep);
        A(:, iCol) = Gscat .* phi_inc;

        %%
        %%  Compute the incident response at the detector.
        %%
        ImageSrc = [Src(1) Src(2) 2*zBnd-Src(3)];
        rsrcdet = norm(Src - Det);
        rimgdet = norm(ImageSrc - Det);
        Phi_Inc(iCol) = exp(j * k * rsrcdet) ./ (-4 * pi * rsrcdet) - ...
            exp(j * k * rimgdet) ./ (-4 * pi * rimgdet) ;

    end
end
A = A.';
fprintf('\n');