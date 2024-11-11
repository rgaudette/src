%DPDWEBornNB    DPDW forward solution in free space using the E-Born approx.
%
%   [phi phi_o] = DPDWEBornNB(CompVol, mu_sp, mu_a, delMu_a, v, idxRefr, f,
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
%  $Date: 2004/01/03 08:27:27 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: DPDWEBornNB.m,v $
%  Revision 1.1.1.1  2004/01/03 08:27:27  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [phi, phi_o] = DPDWEBornNB(CompVol, mu_sp, mu_a, delMu_a, v, ....
    idxRefr, f, pSrc, pDet, Debug)

%%
%%  Compute the PDE parameters from the media parameters
%%
%D = v / (3 * (mu_sp + mu_a));
disp('Using David''s defn: D = v / (3 * mu_sp)')
D = v / (3 * mu_sp);
k_o = sqrt((-v * mu_a + j * 2*pi*f) / D);
if Debug
    fprintf('D = %e\n', D);
    fprintf('Re{k_o} = %e cm^-1\n', real(k_o));
    fprintf('Im{k_o} = %e cm^-1\n', imag(k_o));
end
del_k_sq = -v * delMu_a ./ D;

%%
%%  Calculate the total and incident field from the extended Born approximation.
%%
disp('USING THE MODIFIED EXTENDED BORN APPROX.');

[phi_scat, phi_o] = HlmMEBornNB(CompVol, k_o, del_k_sq, pSrc, pDet, Debug);

phi = -v / D * (phi_scat + phi_o);
phi_o = -v / D * phi_o;