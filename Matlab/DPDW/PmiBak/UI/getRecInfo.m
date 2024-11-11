%GETRECINFO     Get the reconstruction parameters from the GUI.
%
%   ds = getrecinfo(ds)
%
%   ds          The DPDW Imaging data structure to fill in.  If this is not
%               present in the input argument list it will be created.
%
%   GETRECINFO extracts the reconstruction info from the GUI and fills
%   in the DPDW imaging data structure with the appropriate values.
%
%   Calls: none.
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
%  $Log: getRecInfo.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:41  rickg
%  Matlab Source
%
%  Revision 2.0  1998/08/05 16:35:11  rjg
%  Broke up getall.m
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ds = getRecInfo(ds)

if nargin < 1
    ds = [];
end

%%
%%  Get the handle structure from the current figure's user data.
%%
UIHandles = get(gcf, 'UserData');

%%
%%  Reconstruction algorithm
%%
if get(UIHandles.BackProj, 'value')
    ds.Recon.ReconAlg = 'Back Projection';
end

if get(UIHandles.ART, 'value')
    ds.Recon.ReconAlg = 'ART';
    ds.Recon.ARTnIter = eval(get(UIHandles.ARTnIter, 'string'));
end

if get(UIHandles.SIRT, 'value')
    ds.Recon.ReconAlg = 'SIRT';
    ds.Recon.SIRTnIter = eval(get(UIHandles.SIRTnIter, 'string'));
end

if get(UIHandles.MinNorm, 'value')
    ds.Recon.ReconAlg = 'Min. Norm';
end

if get(UIHandles.TSVD, 'value')
    ds.Recon.ReconAlg = 'TSVD';
    ds.Recon.TSVDnSV = eval(get(UIHandles.TSVDnSV, 'string'));
end

if get(UIHandles.MTSVD, 'value')
    ds.Recon.ReconAlg = 'MTSVD';
    ds.Recon.MTSVDnSV = eval(get(UIHandles.MTSVDnSV, 'string'));
    ds.Recon.MTSVDLambda = eval(get(UIHandles.MTSVDLambda, 'string'));
end

if get(UIHandles.TCG, 'value')
    ds.Recon.ReconAlg = 'TCG';
    ds.Recon.TCGnIter = eval(get(UIHandles.TCGnIter, 'string'));
end
