%GETOBJECTINFO  Get the object anomaly info from the GUI.
%
%   ds = getObjectInfo(ds)
%
%   ds          The DPDW Imaging data structure to filled in.  If this is not
%               present in the input argument list it will be created.
%
%   GETOBJECTINFO extracts the anomally data from the GUI and fills
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
%  $Log: getObjectInfo.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:41  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ds = getObjectInfo(ds)

if nargin < 1
    ds = [];
end

%%
%%  Get the handle structure from the current figure's user data.
%%
UIHandles = get(gcf, 'UserData');

%%
%%  Sphere object(s) parameters
%%
strTmp = get(UIHandles.SphereCtr, 'string');
if ~strcmp(strTmp, '')
    ds.Object.SphereCtr = eval(strTmp);
end
strTmp = get(UIHandles.SphereRad, 'string');
if ~strcmp(strTmp, '')
    ds.Object.SphereRad = eval(strTmp);
end
strTmp = get(UIHandles.SphereDelta, 'string');
if ~strcmp(strTmp, '')
    ds.Object.SphereDelta = eval(strTmp);
end

%%
%%  Block object.(s) parameters
%%
strTmp = get(UIHandles.BlockCtr, 'string');
if ~strcmp(strTmp, '')
    ds.Object.BlockCtr = eval(strTmp);
end
strTmp = get(UIHandles.BlockDims, 'string');
if ~strcmp(strTmp, '')
    ds.Object.BlockDims = eval(strTmp);
end
strTmp = get(UIHandles.BlockDelta, 'string');
if ~strcmp(strTmp, '')
    ds.Object.BlockDelta = eval(strTmp);
end
