%HLM3PTBORN1NB  1st Born approx. of a perturbed Helmholtz equation, no boundary.
%
%   [A Phi_Inc] = hlm3ptborn1nb(dr, R, k, pSrc, pDet)
%
%   A           The forward matrix relating the contribution from each voxel to
%               a specific source-detector pair.  Each row is for a different
%               source detector pair.
%
%   Phi_Inc     The incident response at each detector from each source in a
%               column vector.  The same combination pattern as the columns of A.
%
%   dr          The grid size as a vector of the form [dx dy dz].
%
%   R           The region to compute the matrix over in the form
%               [xmin xmax ymin ymax zmin zmax].
%
%   k           The complex wavenumber for the Helmholtz equation.
%
%   pSrc        The position of the source(s) in the form [sx sy sz].
%               Each row represents a different source.
%
%   pDet        The position of the detector(s) in the form [sx sy sz].
%               Each row represents a different detector.
%
%   HLM3PTBORN1NB computes the forward weighting matrix associated with
%   the Born-1 approximation to a spatial varying k.  The incident response
%   at each voxel is first computed and then contribution each detector from
%   each voxel is computed.  This is done for each source as well.
%
%   Do not specify the sources or detector exactly at a sampling point to
%   prevent dived by zero errors when evaluating the Green's functions.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:58 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: hlm3ptborn1nb.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:58  rickg
%  Matlab Source
%
%  Revision 1.3  1998/06/18 15:00:47  rjg
%  Transformed x,y,z locations into column vectors so that it does not
%  have to be done later in functions of these variables.
%  Changed the variable Phi_Det to Phi_Inc since it is the incident field.
%
%  Revision 1.2  1998/06/05 18:12:56  rjg
%  Changed psi to phi.
%
%  Revision 1.1  1998/06/03 16:04:48  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [A, Phi_Inc] = born1fwd(dr, R, k, pSrc, pDet)

nSrc = size(pSrc, 1);
nDet = size(pDet, 1);

%%
%%  Create the sampling volume
%%
Xv = R(1):dr(1):R(2);
Yv = R(3):dr(2):R(4);
Zv = R(5):dr(3):R(6);
[Xm Ym Zm] = meshgrid(Xv, Yv, Zv);
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
    r = sqrt((Xm - Src(1)).^2 + (Ym - Src(2)).^2 + (Zm - Src(3)).^2);
    phi_inc = exp(j * k * r) ./ (-4 * pi * r);
    
    for iDet = 1:nDet
        Det = pDet(iDet,:);
        iCol = iDet + (iSrc-1) * nDet;
      
        %%
        %%  Compute the scattered response at this detector from all
        %%  of the voxels.  Note the that negative sign in the Green's function
        %%  is cancelled by the negative sign in the Born approximation
        %%
        r = sqrt((Xm - Det(1)).^ 2 + (Ym - Det(2)).^2 + (Zm - Det(3)).^2);
        Gscat = exp(i * k * r) ./ (4 * pi * r) * prod(dr);

        A(:, iCol) = Gscat .* phi_inc;

        %%
        %%  Compute the incident response at the detector.
        %%
        rsrcdet = norm(Src - Det);
        Phi_Inc(iCol) = exp(j * k * rsrcdet) ./ (-4 * pi * rsrcdet);
    end
end
A = A.';
fprintf('\n');