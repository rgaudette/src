%HLM3PTBORN1ZB  1st Born approx. of a perturbed Helmholtz equation, z boundary.
%
%   [A Phi_Inc] = hlm3ptborn1zb(CompVol, k, pSrc, pDet, zBnd, Debug)
%
%   A           The forward matrix relating the contribution from each voxel to
%               a specific source-detector pair.  Each row is for a different
%               source detector pair.
%
%   Phi_Inc     The incident response at each detector from each source in a
%               column vector.  The same combination pattern as the columns of A.
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
%   Debug       OPTIONAL: Print out debugging info.
%
%   HLM3PTBORN1ZB computes the forward weighting matrix associated with
%   the Born-1 approximation to a spatial varying k.  A zero fluence boudary
%   condition is implemented at the distance zBnd by mirroring the sources
%   and the pertubation responses.  The sources are assumed to be unit
%   amplitude point sources.
%
%   Do not specify the sources or detector exactly at a sampling point to
%   prevent dived by zero errors when evaluating the Green's functions.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:33 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: Hlm3ptBorn1ZB.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:33  rickg
%  Matlab Source
%
%  Revision 2.1  1999/02/05 20:55:57  rjg
%  Clearified help section.
%
%  Revision 2.0  1998/08/05 15:50:55  rjg
%  Start of version 2
%  Handles structure for computational volume.
%
%  Revision 1.3  1998/06/18 14:56:44  rjg
%  Transformed x,y,z locations into column vectors so that it does not
%  have to be done later in functions of these variables.
%  Changed the variable Phi_Det to Phi_Inc since it is the incident field.
%
%  Revision 1.2  1998/06/05 18:12:20  rjg
%  Changed Psi to Phi.
%
%  Revision 1.1  1998/06/03 16:06:42  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [A, Phi_Inc] = hlm3ptborn1zb(CompVol, k, pSrc, pDet, zBnd, Debug)

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
%%  A is created transposed for better caching performance
%%
A = zeros(nPts, nSrc*nDet) + j * ones(nPts, nSrc*nDet);
Phi_Inc = zeros(nSrc*nDet, 1) + j * ones(nSrc*nDet, 1);

%%
%%  Loop over each source detector combination
%%
if Debug
    fprintf('Src: ');
end

for iSrc = 1:nSrc
    if Debug
        fprintf('%d  ', iSrc);
    end
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
if Debug
    fprintf('\n');
end
