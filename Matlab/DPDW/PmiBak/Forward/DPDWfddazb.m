%DPDWFDDAZB     Variable Absorption Freq. Domain DPDW fwd. matrix z boundary.
%
%   [A Phi_Inc] = dpdwfdda(CompVol, mu_sp, mu_a, v, idxRefr, f, pSrc, pDet, Debug)
%
%   A           The forward matrix relating the contribution from each voxel to
%               a specific source-detector pair.  Each row is for a different
%               source detector pair.
%
%   Phi_Inc     The incident response at each detector from each source
%               in a column vector.  The same combination pattern as the
%               columns of A.
%
%   CompVol     A structure defining the computational volume.  This
%               structure should have the members: Type, X, Y and Z.  Type
%               should be uniform specifying a uniform sampling volume of
%               voxels. X, Y and Z are vectors specifying the centers of the
%               voxels.
%
%   mu_sp       The reduced scattering coefficient.
%
%   mu_a        The background absorption coeffiecient.
%
%   v           The propagation velocity in the medium.
%
%   idxRefr     The indec of refraction for the medium.
%
%   f           The modulation frequency of the source.
%
%   pSrc        The position of the source(s) in the form [sx sy sz].
%               Each row represents a different source.
%
%   pDet        The position of the detector(s) in the form [sx sy sz].
%               Each row represents a different detector.
%
%   Debug       OPTIONAL: Print out debugging info.
%
%   The true z boundary is assumed to be at z=0.
%
%   Calls: hlm3ptborn1zb
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:33 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: DPDWfddazb.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:33  rickg
%  Matlab Source
%
%  Revision 2.1  1999/02/05 20:54:04  rjg
%  Again, changed the value of D, it is now
%  v / (3 * (mu_sp + mu_a))
%
%  Revision 2.0  1998/08/05 15:50:55  rjg
%  Start of version 2
%  Handles structure for computational volume.
%
%  Revision 1.4  1998/06/18 15:08:26  rjg
%  Changed D again to match David's D.  1. removed mu_a from D and
%  2. put v back into D, this did not change k since it was accounted for
%  in previous versions.
%  Scaling of Phi_Inc and A from the Born-Helmholtz approximation was modified for
%  a D without mu_a and negative sign in A that was dropped has be accounted for.
%
%  Revision 1.3  1998/06/10 18:32:39  rjg
%  D is now in units of length, v was removed and move into the imaginary
%  part of k.  This is the same as dividing through the diffusion equation
%  by v.
%  Both Phi_Inc and A are now scaled correctly for the Born-1 approximation,
%  see derivation in notes.
%
%  Revision 1.2  1998/06/05 19:53:06  rjg
%  Changed Psi to Phi
%  Added mu_a to D computation
%  Simplified extraploted boundary computation, no change mathematically.
%  Rescaled Phi by -3/(mu_sp + mu_a) according to David's thesis.
%
%  Revision 1.1  1998/06/03 16:02:56  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [A, Phi_Inc] = dpdwfddazb(CompVol, mu_sp, mu_a, v, idxRefr, f, ...
    pSrc, pDet, Debug)

if nargin < 9
    Debug = 0;
end

%%
%%  Compute the PDE parameters from the media parameters
%%
%D = v / (3 * (mu_sp + mu_a));
disp('Using David''s defn: D = v / (3 * mu_sp)')
D = v / (3 * mu_sp);
k = sqrt(-v * mu_a / D + j * 2*pi*f / D);

if Debug
    fprintf('D = %e\n', D);
    fprintf('Re{k} = %e cm^-1\n', real(k));
    fprintf('Im{k} = %e cm^-1\n', imag(k));
end

%%
%%  This extrapolated boundary condition is from:
%%    Boundary conditions for the diffusion equation in radiative transfer
%%    Haskell et. al.,  J. Opt. Soc. Am - A   Vol. 11, No. 10,  Oct 1994
%%    pg 2727 - 2741
%%
%%
%%  Reff is a linear fit to the table on p. 2731
%%
Reff = (0.493-0.431) / (1.40 - 1.33) * idxRefr - 0.747;
zBnd = 2/3 * (1 + Reff) / (1 - Reff) / mu_sp;
if Debug
    fprintf('Extrapolated boundary = %f cm\n', zBnd);
end

%%
%%  Calculate the Born approximation and incident fields
%%
[A Phi_Inc] = hlm3ptborn1zb(CompVol, k, pSrc, pDet, zBnd);

%%
%%  Scale A and Phi_Inc for the effective source amplitude in Helmholtz
%%  expression for the DPDW equation.  Addditionally, scale A as the
%%  mapping from del mu_a to the scattered fluence.  The Born-1
%%  approximation maps a change in k to the scattered fluence.
%%
Phi_Inc = -v / D * Phi_Inc;
A = (v / D)^2 * A;