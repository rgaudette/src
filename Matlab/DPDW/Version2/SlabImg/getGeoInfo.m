%GETGEOINFO     Get the geometry info from the GUI.
%
%   ds = getgeoinfo(ds)
%
%   ds          The Slab Image data structure to fill in.  If this is not
%               present in the input argument list it will be created.
%
%   GETGEOINFO extracts the geometry info from the GUI and fills
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
%  $Log: getGeoInfo.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:14  rickg
%  Matlab Source
%
%  Revision 2.0  1998/08/05 16:36:16  rjg
%  Broke up getall.m
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ds = getgeoinfo(ds)

if nargin < 1
    ds = [];
end

%%
%%  Get the handle structure from the current figure's user data.
%%
UIHandles = get(gcf, 'UserData');

%%
%%  Computation Volume Parameters
%%
XMin = eval(get(UIHandles.XMin, 'string'));
XMax = eval(get(UIHandles.XMax, 'string'));
XStep = eval(get(UIHandles.XStep, 'string'));
YMin = eval(get(UIHandles.YMin, 'string'));
YMax = eval(get(UIHandles.YMax, 'string'));
YStep = eval(get(UIHandles.YStep, 'string'));
ZMin = eval(get(UIHandles.ZMin, 'string'));
ZMax = eval(get(UIHandles.ZMax, 'string'));
ZStep = eval(get(UIHandles.ZStep, 'string'));
CompVol.Type = 'uniform';
CompVol.X = [XMin:XStep:XMax];
CompVol.Y = [YMin:YStep:YMax];
CompVol.Z = [ZMin:ZStep:ZMax];
CompVol.XStep = XStep;
CompVol.YStep = YStep;
CompVol.ZStep = ZStep;
ds.CompVol = CompVol;

%%
%%  Source & Detector Data
%%
SrcPos.Type = 'uniform';
SrcPos.X = eval(get(UIHandles.SrcXPos, 'string'));
SrcPos.Y = eval(get(UIHandles.SrcYPos, 'string'));
SrcPos.Z = eval(get(UIHandles.SrcZPos, 'string'));
ds.SrcPos = SrcPos;
ds.SrcAmp = eval(get(UIHandles.SrcAmp, 'string'));
DetPos.Type = 'uniform';
DetPos.X = eval(get(UIHandles.DetXPos, 'string'));
DetPos.Y = eval(get(UIHandles.DetYPos, 'string'));
DetPos.Z = eval(get(UIHandles.DetZPos, 'string'));;
ds.DetPos = DetPos;
ds.SensorError = eval(get(UIHandles.SensorError, 'string'));
ds.ModFreq = eval(get(UIHandles.ModFreq, 'string'));

%%
%%  Medium paramters
%%
ds.idxRefr = eval(get(UIHandles.idxRefr, 'string'));
ds.g = eval(get(UIHandles.g, 'string'));
ds.Mu_s = eval(get(UIHandles.Mu_s, 'string'));
ds.Mu_a = eval(get(UIHandles.Mu_a, 'string'));
ds.Mu_sp = ds.Mu_s * (1 - ds.g);
ds.nu = 3.0E10 ./ ds.idxRefr;

if get(UIHandles.InfMedium, 'value')
    ds.Boundary = 'Infinite';
end
if get(UIHandles.ExtrapBnd, 'value')
    ds.Boundary = 'Extrapolated';
end
