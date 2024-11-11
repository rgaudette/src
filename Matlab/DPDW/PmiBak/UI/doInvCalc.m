%doInvCalc      Calculate the forward system matrix for the inverse problem
%
%   This script extracts the current system parameters from the GUI Slab
%   image interface and calculates the forward matrix for the inverse
%   problem specified by the parameters as well as the incident detector
%   fluence.
%
%   Calls: getInvModelInfo, getinvmat
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:41 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: doInvCalc.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:41  rickg
%  Matlab Source
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
ds = getInvModelInfo(ds);

%%
%%  Calculate the forward matrix and incident fields returning all
%%  results in data structure.
%%
ds.Inv = genFwdMat(ds.Inv, ds.Debug);

%%
%%  Reweight the forward matrix if the weighting vector exists
%%
if isfield(ds, 'Noise')
    if isfield(ds.Noise, 'w')
        if ds.Noise.SrcSNRflag
            if ds.Debug
                disp('Re-Weighting for non-white noise');
            end
            ds.Inv.Aw = rowscale(ds.Inv.A, ds.Noise.w);
        else
            if ds.Debug
                disp('Uniform noise: No weighting applied, ds.Inv.Aw updated');
            end
            ds.Inv.Aw = ds.Inv.A;
        end
    end
end
ds.Recon.flgNeedFullSVD = 1;
ds.Recon.flgNeedEconSVD = 1;
  
set(UIHandles.hLight, 'Color', [0 1 0]);
drawnow;
clear UIHandles;
