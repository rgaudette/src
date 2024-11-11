%DPDWFDDA       Variable Absorption Freq. Domain DPDW fwd. matrix.
%
%   [A Phi_Inc] = dpdwfdda(dr, R, mu_sp, mu_a, nu, f, pSrc, pDet)
%
%   A           The forward matrix relating the contribution from each voxel to
%               a specific source-detector pair.  Each row is for a different
%               source detector pair.
%
%   Phi_Det     The incident response at each detector from each source in a
%               column vector.  The same combination pattern as the columns of A.
%
%   dr         The grid size as a vector of the form [dx dy dz].
%
%   R          The region to compute the matrix over in the form
%               [xmin xmax ymin ymax zmin zmax].
%
%   mu_sp      The reduced scattering coefficient.
%
%   mu_a       The background absorption coeffiecient.
%
%   nu         The propagation velocity in the medium.
%
%   f          The modulation frequency of the source.
%
%   pSrc       The position of the source(s) in the form [sx sy sz].
%               Each row represents a different source.
%
%   pDet       The position of the detector(s) in the form [sx sy sz].
%               Each row represents a different detector.
%
%   Calls: hlm3ptborn1nb
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:57 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: dpdwfdda.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:57  rickg
%  Matlab Source
%
%  Revision 1.4  1998/06/18 15:07:31  rjg
%  Changed D again to match David's D.  1. removed mu_a from D and 
%  2. put nu back into D, this did not change k since it was accounted for
%  in previous versions.
%  Scaling of Phi_Inc and A from the Born-Helmholtz approximation was modified for
%  a D without mu_a and negative sign in A that was dropped has be accounted for.
%
%  Revision 1.3  1998/06/10 18:33:27  rjg
%  D is now in units of length, nu was removed and move into the imaginary
%  part of k.  This is the same as dividing through the diffusion equation
%  by nu.
%  Both Phi_Inc and A are now scaled correctly for the Born-1 approximation,
%  see derivation in notes.
%
%  Revision 1.2  1998/06/05 18:13:39  rjg
%  Changed psi to phi.
%
%  Revision 1.1  1998/06/03 16:03:16  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [A, Phi_Inc] = dpdwfdda(dr, R, mu_sp, mu_a, nu, f, pSrc, pDet)

%%
%%  Compute the PDE parameters from the media parameters
%%
D = nu / (3 * mu_sp);
k = sqrt(j*2*pi*f * 3 * mu_sp /nu - 3 * mu_sp * mu_a);

fprintf('D = %e\n', D);
fprintf('Re{k} = %f cm^-1\n', real(k));
fprintf('Im{k} = %f cm^-1\n', imag(k));

[A Phi_Inc] = hlm3ptborn1nb(dr, R, k, pSrc, pDet);

%%
%%  Scale A and Phi_Inc for the effective source amplitude in Helmholtz
%%  expression for the DPDW equation.  Addditionally, scale A as the
%%  mapping from del mu_a to the scattered fluence.  The Born-1
%%  approximation maps a change in k to the scattered fluence.
%%
Phi_Inc = -3 * mu_sp * Phi_Inc;
A = 9 * mu_sp^2 * A;
