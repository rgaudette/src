%doMeasData     Calculate the measured data from the slab image parms.
%
%   This script extracts the current system parameters from the GUI Slab
%   image interface and calculates the measured data (detector responses).
%
%   Calls: gensphere1
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
%  $Lo doMeasData.m,v $
%  Revision 1.2  1998/04/29 15:13:04  rjg
%  Added busy light.
%
%  Revision 1.1  1998/04/28 20:17:51  rjg
%  Initial revision
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

UIHandles = get(gcf, 'UserData');
set(UIHandles.hLight, 'Color', [1 0 0]);
drawnow;

ds = getall;
%%
%%  Generate measured data
%%
switch ds.DataSource

case 'Matlab Variable' 
    %%
    %%  Matlab variable data should be a matrix with 2 columns, the first ...
    %%  colum should contain the total fluence measurement and the second ...
    %%  column should contain the incident fluence level.
    %%
    Fluence = eval(ds.MatlabVarName);
    Phi_Total = Fluence(:,1);
    Phi_Inc = Fluence(:,2);
    Phi_Scat = Phi_Total - Phi_Inc;
    
case 'Born-1'
    %%
    %%  Generate the volume data using the 1st born method
    %%
    del_mu_a = gensphere1(dr, R, ds.SphereCtr, ds.SphereRad, ds.SphereDelta);
    Phi_Scat = A * del_mu_a(:);
    Phi_Total = Phi_Inc + Phi_Scat;
    
otherwise
    error('Unknown data source')
end

IPR = abs(Phi_Inc) ./ abs(Phi_Scat);
fprintf('Max Incident-to-Purturbation-Ratio: %f dB\n', ...
    20*log10(max(IPR)));
fprintf('Min Incident-to-Purturbation-Ratio: %f dB\n', ...
    20*log10(min(IPR)));

%%
%%  Add source side noise if selected
%%
Phi_ScatN = Phi_Scat;
if ds.SrcSNRflag
    SrcNoiseGain = zeros(size(Phi_Total));
    for iMeas = 1:length(Phi_Total);
        SrcNoiseGain(iMeas)  = abs(Phi_Total(iMeas)) *...
            (10 ^ (-1 * ds.SrcSNR / 20));
    end
    SrcNoise = randn(size(Phi_Total)) .* SrcNoiseGain;
    Phi_ScatN = Phi_ScatN + SrcNoise;
    fprintf('Max source noise std %e\n', max(SrcNoiseGain));
    fprintf('Min source noise std %e\n\n', min(SrcNoiseGain));
end

%%
%%  Add detector side noise if selected
%%
if ds.DetSNRflag
    DetNoiseGain = max(abs(Phi_Total)) * (10 ^ (-1 * ds.DetSNR / 20));
    DetNoise = randn(size(Phi_Scat)) * DetNoiseGain;
    Phi_ScatN = Phi_ScatN + DetNoise;
    fprintf('Detector noise std %e\n\n', DetNoiseGain);
end


%%
%%  Add scattered ratio noise if selected
%%
if ds.ScatSNRflag
    ScatNoiseSTD = zeros(size(Phi_Scat));
    for iMeas = 1:length(Phi_Scat);
        ScatNoiseSTD(iMeas)  = abs(Phi_Scat(iMeas)) *...
            (10 ^ (-1 * ds.ScatSNR / 20));
    end
    ScatNoise = randn(size(Phi_Scat)) .* ScatNoiseSTD;
    Phi_ScatN = Phi_ScatN + ScatNoise;
    fprintf('Max scattered ratio noise std %e\n', max(ScatNoiseSTD));
    fprintf('Min scattered noise std %e\n\n', min(ScatNoiseSTD));
end

set(UIHandles.hLight, 'Color', [0 1 0]);
drawnow;
