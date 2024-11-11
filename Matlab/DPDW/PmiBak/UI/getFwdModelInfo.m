%GETFWDMODELINFO Get the geometry info from the GUI.
%
%   ds = getFwdModelInfo(ds)
%
%   ds          The DPDW Imaging data structure to fill in.  If this is not
%               present in the input argument list it will be created.
%
%   GETGEOINFO extracts the forward model info from the GUI and fills
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
%  $Log: getFwdModelInfo.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:41  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ds = getFwdModelInfo(ds)

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
ds.Fwd.idxRefr = eval(get(UIHandles.Fwd_idxRefr, 'string'));
ds.Fwd.Mu_s = eval(get(UIHandles.Fwd_Mu_s, 'string'));
ds.Fwd.g = eval(get(UIHandles.Fwd_g, 'string'));
ds.Fwd.Mu_a = eval(get(UIHandles.Fwd_Mu_a, 'string'));
ds.Fwd.Mu_sp = ds.Fwd.Mu_s * (1 - ds.Fwd.g);
ds.Fwd.v = 3.0E10 ./ ds.Fwd.idxRefr;

%%
%%  Source & Detector Data
%%
SrcPos.Type = 'uniform';
SrcPos.X = eval(get(UIHandles.Fwd_SrcXPos, 'string'));
SrcPos.Y = eval(get(UIHandles.Fwd_SrcYPos, 'string'));
SrcPos.Z = eval(get(UIHandles.Fwd_SrcZPos, 'string'));
ds.Fwd.SrcPos = SrcPos;
ds.Fwd.SrcAmp = eval(get(UIHandles.Fwd_SrcAmp, 'string'));
DetPos.Type = 'uniform';
DetPos.X = eval(get(UIHandles.Fwd_DetXPos, 'string'));
DetPos.Y = eval(get(UIHandles.Fwd_DetYPos, 'string'));
DetPos.Z = eval(get(UIHandles.Fwd_DetZPos, 'string'));;
ds.Fwd.DetPos = DetPos;

str = get(UIHandles.Fwd_SensorError, 'string');
if ~isempty(str)
    ds.Fwd.SensorError = eval(str);
end

ds.Fwd.ModFreq = eval(get(UIHandles.Fwd_ModFreq, 'string'));

if get(UIHandles.Fwd_InfMedium, 'value')
    ds.Fwd.Boundary = 'Infinite';
end
if get(UIHandles.Fwd_ExtrapBnd, 'value')
    ds.Fwd.Boundary = 'Extrapolated';
end

%%
%%  Forward model method
%%
if get(UIHandles.Fwd_MatlabVar,'value')
    ds.Fwd.Method.Type = 'Matlab Variable'
    ds.Fwd.Method.MatlabVarName = eval(get(UIHandles.Fwd_MatlabVarName, ...
        'string'));
end
if get(UIHandles.Fwd_Born,'value')
    ds.Fwd.Method.Type = 'Born';
    ds.Fwd.Method.Order = eval(get(UIHandles.Fwd_Order, 'string'));
end
if get(UIHandles.Fwd_Rytov,'value')
    ds.Fwd.Method.Type = 'Rytov';
    ds.Fwd.Method.Order = eval(get(UIHandles.Fwd_Order, 'string'));
end
if get(UIHandles.Fwd_Spherical,'value')
    ds.Fwd.Method.Type = 'Spherical';
    ds.Fwd.Method.Order = eval(get(UIHandles.Fwd_Order, 'string'));
end

if get(UIHandles.Fwd_FDFD,'value')
    ds.Fwd.Method.Type = 'FDFD';
end
if get(UIHandles.Fwd_FiniteElem,'value')
    ds.Fwd.Method.Type = 'FEM';
end

if ~(strcmp(ds.Fwd.Method.Type, 'Spherical') | ...
        strcmp(ds.Fwd.Method.Type, 'MatlabVariable'))
    %%
    %%  Computation Volume Parameters
    %%
    XMin = eval(get(UIHandles.Fwd_XMin, 'string'));
    XMax = eval(get(UIHandles.Fwd_XMax, 'string'));
    XStep = eval(get(UIHandles.Fwd_XStep, 'string'));
    YMin = eval(get(UIHandles.Fwd_YMin, 'string'));
    YMax = eval(get(UIHandles.Fwd_YMax, 'string'));
    YStep = eval(get(UIHandles.Fwd_YStep, 'string'));
    ZMin = eval(get(UIHandles.Fwd_ZMin, 'string'));
    ZMax = eval(get(UIHandles.Fwd_ZMax, 'string'));
    ZStep = eval(get(UIHandles.Fwd_ZStep, 'string'));
    CompVol.Type = 'uniform';
    CompVol.X = [XMin:XStep:XMax];
    CompVol.Y = [YMin:YStep:YMax];
    CompVol.Z = [ZMin:ZStep:ZMax];
    CompVol.XStep = XStep;
    CompVol.YStep = YStep;
    CompVol.ZStep = ZStep;
    ds.Fwd.CompVol = CompVol;
end
