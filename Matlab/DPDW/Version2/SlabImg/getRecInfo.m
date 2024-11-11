%GETRECINFO     Get the reconstruction parameters from the GUI.
%
%   ds = getrecinfo(ds)
%
%   ds          The Slab Image data structure to fill in.  If this is not
%               present in the input argument list it will be created.
%
%   GETRECINFO extracts the reconstruction info from the GUI and fills
%   in the slab image data structure with the appropriate values.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:14 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: getRecInfo.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:14  rickg
%  Matlab Source
%
%  Revision 2.0  1998/08/05 16:35:11  rjg
%  Broke up getall.m
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ds = getrecinfo(ds)

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
    ds.ReconAlg = 'Back Projection';
end

if get(UIHandles.ART, 'value')
    ds.ReconAlg = 'ART';
    ds.ARTnIter = eval(get(UIHandles.ARTnIter, 'string'));
end

if get(UIHandles.SIRT, 'value')
    ds.ReconAlg = 'SIRT';
    ds.SIRTnIter = eval(get(UIHandles.SIRTnIter, 'string'));
end

if get(UIHandles.MinNorm, 'value')
    ds.ReconAlg = 'Min. Norm';
end

if get(UIHandles.TSVD, 'value')
    ds.ReconAlg = 'TSVD';
    ds.TSVDnSV = eval(get(UIHandles.TSVDnSV, 'string'));
end

if get(UIHandles.MTSVD, 'value')
    ds.ReconAlg = 'MTSVD';
    ds.MTSVDnSV = eval(get(UIHandles.MTSVDnSV, 'string'));
    ds.MTSVDLambda = eval(get(UIHandles.MTSVDLambda, 'string'));
end

if get(UIHandles.TCG, 'value')
    ds.ReconAlg = 'TCG';
    ds.TCGnIter = eval(get(UIHandles.TCGnIter, 'string'));
end
