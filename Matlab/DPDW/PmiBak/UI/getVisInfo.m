%GETVISINFO     Get the visualization info from the GUI.
%
%   ds = getvisinfo(ds)
%
%   ds          The DPDW Imaging data structure to fill in.  If this is not
%               present in the input argument list it will be created.
%
%   GETVISINFO extracts the visualization info from the GUI and fills
%   in the DPDW Imaging data structure with the appropriate values.
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
%  $Log: getVisInfo.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:41  rickg
%  Matlab Source
%
%  Revision 2.1  1998/08/07 21:31:07  rjg
%  Added radio button for selecting which dimension to slice in.
%
%  Revision 2.0  1998/08/05 16:32:50  rjg
%  *** empty log message ***
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ds = getVisInfo(ds)

if nargin < 1
    ds = [];
end

%%
%%  Get the handle structure from the current figure's user data.
%%
UIHandles = get(gcf, 'UserData');


%%
%%  Visualiztion parameters
%%
if get(UIHandles.XPlane, 'value')
    ds.Visualize.VisPlane = 'X';
end
if get(UIHandles.YPlane, 'value')
    ds.Visualize.VisPlane = 'Y';
end
if get(UIHandles.ZPlane, 'value')
    ds.Visualize.VisPlane = 'Z';
end

if get(UIHandles.Image, 'value')
    ds.Visualize.Type = 'image';
else
    ds.Visualize.Type = 'contour';
    ds.Visualize.nCLines = eval(get(UIHandles.nCLines, 'string'));
end

ds.Visualize.PlaneIndices = eval(get(UIHandles.PlaneIndices, 'string'));
ds.Visualize.LayoutVector = eval(get(UIHandles.LayoutVector, 'string'));

if get(UIHandles.CMapBgyor, 'value')
    ds.Visualize.CMap = 'bgyor';
else
    ds.Visualize.CMap = 'grey';
end

if get(UIHandles.CRangeAuto, 'value')
    ds.Visualize.CRange = 'auto';
else
    ds.Visualize.CRange = 'fixed';
    ds.Visualize.CRangeVal = eval(get(UIHandles.CRangeVal, 'string'));
end
