%doFwdCalc      Calculate the forward system matrix from the slab image parms.
%
%   This script extracts the current system parameters from the GUI Slab
%   image interface and calculates the forward matrix specified by the
%   parameters as well as the incident detector fluence.
%
%   Calls: getall, dpdwfdda, dpdwfddazb, 
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:56 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: doFwdCalc.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:56  rickg
%  Matlab Source
%
%  Revision 1.7  1998/07/30 19:44:04  rjg
%  Changed boundary condition to switch on string values instead of codes.
%
%  Revision 1.6  1998/06/10 18:19:19  rjg
%  Fixed modulation frequency bug.  Previous version passed frequency in
%  Hz instead of MHz
%  Added correct handling of incident field for multiple frequencies.
%  Removed temporary forward matrix and incident vector
%
%  Revision 1.5  1998/06/05 17:43:39  rjg
%  Fixed bug where diffuse source depth was calculated as 10 diffusion
%  lengths instead of 1!!!
%  Added print out of diffuse source depth.
%
%  Revision 1.4  1998/06/04 15:37:26  rjg
%  Restructured incident fluence for non-zero frequencies by stacking real
%  over imaginary parts.
%
%  Revision 1.3  1998/06/03 16:18:09  rjg
%  Added parameter reporting code.
%  Add flags for econ/normal SVD requirement, removed single flag.
%
%  Revision 1.2  1998/04/29 15:12:38  rjg
%  Added busy light.
%
%  Revision 1.1  1998/04/28 20:15:17  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%  Set the busy light to red
%%
UIHandles = get(gcf, 'UserData');
set(UIHandles.hLight, 'Color', [1 0 0]);
drawnow;

%%
%%  Get all of the measurement parameters from GUI
%%
ds = getall;

dr = [ds.XStep ds.YStep ds.ZStep];
R = [ds.XMin ds.XMax ds.YMin ds.YMax ds.ZMin ds.ZMax];

%%
%%  Medium parameters
%%
nu = 3E10 / ds.idxRefr;
mu_sp = ds.Mu_s * (1 - ds.g);
SourceOffset = 1 / mu_sp;

fprintf('\nMedium propagation velocity: %e cm/sec\n', nu);
fprintf('mu_s: %f cm^-1    mu_s'': %f cm^-1\n', ds.Mu_s, mu_sp);
fprintf('mu_a: %f cm^-1\n', ds.Mu_a);
fprintf('Diffuse source depth %f cm\n', SourceOffset);

%%
%%  Source modulation frequency and source & detector positions
%%
[Xp Yp] = meshgrid(ds.SrcXPos, ds.SrcYPos);
nSrc = prod(size(Xp));
pSrc = [Xp(:) Yp(:) -1*SourceOffset*ones(nSrc,1)];

[Xp Yp] = meshgrid(ds.DetXPos, ds.DetYPos);
nDet = prod(size(Xp));
pDet = [Xp(:) Yp(:) zeros(nDet,1)];
clear Xp Yp

%%
%%  Generate a forward matrix for each frequency
%%

A = [];
Phi_Inc = [];
for idxFreq = 1:length(ds.ModFreq)
    f = ds.ModFreq(idxFreq) * 1E6;
    fprintf('Modulation Freq: %e Hz\n', f);

    switch ds.Boundary
    case 'Extrapolated'
        fprintf('Executing extrapolated zero boundary computation\n');
        [tmpA tmpPhi_Inc] = dpdwfddazb(dr, R, mu_sp, ds.Mu_a, nu, f, pSrc, pDet);
    case 'Infinite'
        fprintf('Executing infinite medium boundary computation\n');
        [tmpA tmpPhi_Inc] = dpdwfdda(dr, R, mu_sp, ds.Mu_a, nu, f, pSrc, pDet);
    otherwise
        error('Unknown boundary condition');
    end


    if f > 0
        A = [A; real(tmpA); imag(tmpA)];
        Phi_Inc = [Phi_Inc; real(tmpPhi_Inc); imag(tmpPhi_Inc)];
    else
        A = [A; real(tmpA)];
        Phi_Inc = [Phi_Inc; real(tmpPhi_Inc)];    
    end
end
clear tmpA tmpPhi_Inc

flgNeedFullSVD = 1;
flgNeedEconSVD = 1;

set(UIHandles.hLight, 'Color', [0 1 0]);
drawnow;
