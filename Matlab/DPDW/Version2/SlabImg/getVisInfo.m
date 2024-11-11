%GETVISINFO     Get the visualization info from the GUI.
%
%   ds = getvisinfo(ds)
%
%   ds          The Slab Image data structure to fill in.  If this is not
%               present in the input argument list it will be created.
%
%   GETVISINFO extracts the visualization info from the GUI and fills
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
%  $Log: getVisInfo.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:14  rickg
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

function ds = getvisinfo(ds)

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
    ds.VisPlane = 'X';
end
if get(UIHandles.YPlane, 'value')
    ds.VisPlane = 'Y';
end
if get(UIHandles.ZPlane, 'value')
    ds.VisPlane = 'Z';
end

if get(UIHandles.Image, 'value')
    ds.Visualize = 'image';

else
    ds.Visualize = 'contour';
    ds.nCLines = eval(get(UIHandles.nCLines, 'string'));
end

ds.PlaneIndices = eval(get(UIHandles.PlaneIndices, 'string'));
ds.LayoutVector = eval(get(UIHandles.LayoutVector, 'string'));

if get(UIHandles.CMapBgyor, 'value')
    ds.CMap = 'bgyor';
else
    ds.CMap = 'grey';
end

if get(UIHandles.CRangeAuto, 'value')
    ds.CRange = 'auto';
else
    ds.CRange = 'fixed';
    ds.CRangeVal = eval(get(UIHandles.CRangeVal, 'string'));
end
