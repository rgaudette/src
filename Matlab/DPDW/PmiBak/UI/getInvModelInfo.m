%GETINVMODELINFO Get the geometry info from the GUI.
%
%   ds = getInvModelInfo(ds)
%
%   ds          The DPDW Imaging data structure to fill in.  If this is not
%               present in the input argument list it will be created.
%
%   GETGEOINFO extracts the inverse model info from the GUI and fills
%   in the DPDW image data structure with the appropriate values.
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
%  $Log: getInvModelInfo.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:41  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ds = getInvModelInfo(ds)

if nargin < 1
    ds = [];
end

%%
%%  Get the handle structure from the current figure's user data.
%%
UIHandles = get(gcf, 'UserData');

if ~isfield(ds, 'Version')
    ds.Version = 3;
end
if ~isfield(ds, 'Debug')
    ds.Debug = 0;
end


%%
%%  Medium paramters
%%
ds.Inv.idxRefr = eval(get(UIHandles.Fwd_idxRefr, 'string'));
ds.Inv.Mu_s = eval(get(UIHandles.Fwd_Mu_s, 'string'));
ds.Inv.g = eval(get(UIHandles.Fwd_g, 'string'));
ds.Inv.Mu_a = eval(get(UIHandles.Inv_Mu_a, 'string'));
ds.Inv.Mu_sp = ds.Inv.Mu_s * (1 - ds.Inv.g);
ds.Inv.v = 3.0E10 ./ ds.Inv.idxRefr;

%%
%%  Source & Detector Data
%%
SrcPos.Type = 'uniform';
SrcPos.X = eval(get(UIHandles.Inv_SrcXPos, 'string'));
SrcPos.Y = eval(get(UIHandles.Inv_SrcYPos, 'string'));
SrcPos.Z = eval(get(UIHandles.Inv_SrcZPos, 'string'));
ds.Inv.SrcPos = SrcPos;
ds.Inv.SrcAmp = eval(get(UIHandles.Inv_SrcAmp, 'string'));
DetPos.Type = 'uniform';
DetPos.X = eval(get(UIHandles.Inv_DetXPos, 'string'));
DetPos.Y = eval(get(UIHandles.Inv_DetYPos, 'string'));
DetPos.Z = eval(get(UIHandles.Inv_DetZPos, 'string'));;
ds.Inv.DetPos = DetPos;

str = get(UIHandles.Inv_SensorError, 'string');
if ~isempty(str)
    ds.Inv.SensorError = eval(str);
end

ds.Inv.ModFreq = eval(get(UIHandles.Inv_ModFreq, 'string'));

if get(UIHandles.Inv_InfMedium, 'value')
    ds.Inv.Boundary = 'Infinite';
end
if get(UIHandles.Inv_ExtrapBnd, 'value')
    ds.Inv.Boundary = 'Extrapolated';
end

%%
%%  Forward model method
%%
if get(UIHandles.Inv_Born,'value')
    ds.Inv.Method = 'Born';
end
if get(UIHandles.Inv_Rytov,'value')
    ds.Inv.Method = 'Rytov';
end

%%
%%  Computation Volume Parameters
%%
XMin = eval(get(UIHandles.Inv_XMin, 'string'));
XMax = eval(get(UIHandles.Inv_XMax, 'string'));
XStep = eval(get(UIHandles.Inv_XStep, 'string'));
YMin = eval(get(UIHandles.Inv_YMin, 'string'));
YMax = eval(get(UIHandles.Inv_YMax, 'string'));
YStep = eval(get(UIHandles.Inv_YStep, 'string'));
ZMin = eval(get(UIHandles.Inv_ZMin, 'string'));
ZMax = eval(get(UIHandles.Inv_ZMax, 'string'));
ZStep = eval(get(UIHandles.Inv_ZStep, 'string'));
CompVol.Type = 'uniform';
CompVol.X = [XMin:XStep:XMax];
CompVol.Y = [YMin:YStep:YMax];
CompVol.Z = [ZMin:ZStep:ZMax];
CompVol.XStep = XStep;
CompVol.YStep = YStep;
CompVol.ZStep = ZStep;
ds.Inv.CompVol = CompVol;
