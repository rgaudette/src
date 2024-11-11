%DPDWEBornZB    DPDW forward solution in a half space using the E-Born approx.
%
%   [phi phi_o] = DPDWEBornZB(CompVol, mu_sp, mu_a, delMu_a, v, idxRefr, f,
%                             pSrc, pDet, Debug)
%
%   
%
%   parm        Input description [units: MKS].
%
%   Optional    OPTIONAL: This parameter is optional (default: value).
%
%
%   TEMPLATE Describe function, it's methods and results.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:27:29 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: DPDWEBornZB.m,v $
%  Revision 1.1.1.1  2004/01/03 08:27:29  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [phi, phi_o] = DPDWEBornZB(CompVol, mu_sp, mu_a, delMu_a, v, ....
    idxRefr, f, pSrc, pDet, Debug)

%%
%%  Compute the PDE parameters from the media parameters
%%
%D = v / (3 * (mu_sp + mu_a));
disp('Using David''s defn: D = v / (3 * mu_sp)')
D = v / (3 * mu_sp);
k_o = sqrt(-v * mu_a / D + j * 2*pi*f / D);
if Debug
    fprintf('D = %e\n', D);
    fprintf('Re{k_o} = %e cm^-1\n', real(k_o));
    fprintf('Im{k_o} = %e cm^-1\n', imag(k_o));
end
del_k = sqrt(-v * delMu_a ./ D);

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
%%  Calculate the total and incident field from the extended Born approximation.
%%
[phi, phi_o] = HlmEBornZB(CompVol, k_o, del_k, pSrc, pDet, zBnd, Debug);
phi = -v / D * phi;
phi_o = -v / D * phi_o;