%GETMDINFO      Get the measured data source info from the GUI.
%
%   ds = getmdinfo(ds)
%
%   ds          The Slab Image data structure to fill in.  If this is not
%               present in the input argument list it will be created.
%
%   GETMDINFO extracts the measured data source info from the GUI and fills
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
%  $Log: getMDInfo.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:14  rickg
%  Matlab Source
%
%  Revision 2.1  1999/02/05 20:44:49  rjg
%  Added code to get vector norm noise parameters and block
%  object parameters
%
%  Revision 2.0  1998/08/05 16:34:27  rjg
%  Broke up getall.m
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ds = getMDInfo(ds)

if nargin < 1
    ds = [];
end

%%
%%  Get the handle structure from the current figure's user data.
%%
UIHandles = get(gcf, 'UserData');

%%
%%  Data source parameters
%%
if get(UIHandles.MatlabVar,'value')
    ds.DataSource = 'Matlab Variable'
    ds.MatlabVarName = eval(get(UIHandles.MatlabVarName, 'string'));
end
if get(UIHandles.PMI,'value')
    ds.DataSource = 'PMI Script'
    ds.PMIFile = eval(get(UIHandles.PMIFileName, 'string'));
end
if get(UIHandles.Born1,'value')
    ds.DataSource = 'Born-1';
end
if get(UIHandles.Rytov,'value')
    ds.DataSource = 'Rytov-1';
end
if get(UIHandles.FDFD,'value')
    ds.DataSource = 'FDFD';
end
if get(UIHandles.FiniteElem,'value')
    ds.DataSource = 'FEM';
end

%%
%%  Noise level parameters
%%
ds.SrcSNRflag = get(UIHandles.SrcSNRflag,'value');
temp = get(UIHandles.SrcSNR,'string');
if ~isempty(temp)
    ds.SrcSNR = eval(get(UIHandles.SrcSNR, 'string'));
end

ds.DetSNRflag = get(UIHandles.DetSNRflag,'value');
temp = get(UIHandles.DetSNR,'string');
if ~isempty(temp)
    ds.DetSNR = eval(get(UIHandles.DetSNR, 'string'));
end

ds.ScatSNRflag = get(UIHandles.ScatSNRflag,'value');
temp = get(UIHandles.ScatSNR,'string');
if ~isempty(temp)
    ds.ScatSNR = eval(get(UIHandles.ScatSNR, 'string'));
end

ds.VecNormSNRflag = get(UIHandles.VecNormSNRflag,'value');
temp = get(UIHandles.VecNormSNR,'string');
if ~isempty(temp)
    ds.VecNormSNR = eval(get(UIHandles.VecNormSNR, 'string'));
end


%%
%%  Sphere object(s) parameters
%%
strTmp = get(UIHandles.SphereCtr, 'string');
if ~strcmp(strTmp, '')
    ds.SphereCtr = eval(strTmp);
end
strTmp = get(UIHandles.SphereRad, 'string');
if ~strcmp(strTmp, '')
    ds.SphereRad = eval(strTmp);
end
strTmp = get(UIHandles.SphereDelta, 'string');
if ~strcmp(strTmp, '')
    ds.SphereDelta = eval(strTmp);
end

%%
%%  Block object(s) parameters
%%
strTmp = get(UIHandles.BlockCtr, 'string');
if ~strcmp(strTmp, '')
    ds.BlockCtr = eval(strTmp);
end
strTmp = get(UIHandles.BlockDims, 'string');
if ~strcmp(strTmp, '')
    ds.BlockDims = eval(strTmp);
end
strTmp = get(UIHandles.BlockDelta, 'string');
if ~strcmp(strTmp, '')
    ds.BlockDelta = eval(strTmp);
end
