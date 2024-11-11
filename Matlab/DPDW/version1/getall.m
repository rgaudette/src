%GETALL         Return all of the system parameter from the Slab Image GUI.
%
%   stSlabImg = getall;
%
%   stSlabImg   The structure containing all of the Slab Image parameters.
%
%
%   GETALL queries each known edit or radio button control to fill in the
%   all of the members of the data structure.  The GUI must be the current
%   figure.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:57 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: getall.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:57  rickg
%  Matlab Source
%
%  Revision 1.6  1998/07/30 19:58:35  rjg
%  Removed SIdefines codes, uses string now.
%  Added parameters for the three noise models
%  Added parameters for TCG
%
%  Revision 1.5  1998/06/03 16:39:02  rjg
%  Uses SIdefines codes
%  MTSVD parameters
%
%  Revision 1.4  1998/04/29 16:10:32  rjg
%  Fixed else statment reporting ans, changed to elseif.
%  
%  Added comments.
%
%  Revision 1.3  1998/04/29 15:15:28  rjg
%  Added visualization techniques members.
%
%  Revision 1.2  1998/04/28 20:26:12  rjg
%  Added to help.
%
%  Revision 1.1  1998/04/28 20:24:42  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ds = getall

%%
%%  Get the handle structure from the current figure's user data.
%%
UIHandles = get(gcf, 'UserData');

%%
%%  Computation Volume Parameters
%%
ds.XMin = eval(get(UIHandles.XMin, 'string'));
ds.XMax = eval(get(UIHandles.XMax, 'string'));
ds.XStep = eval(get(UIHandles.XStep, 'string'));
ds.YMin = eval(get(UIHandles.YMin, 'string'));
ds.YMax = eval(get(UIHandles.YMax, 'string'));
ds.YStep = eval(get(UIHandles.YStep, 'string'));
ds.ZMin = eval(get(UIHandles.ZMin, 'string'));
ds.ZMax = eval(get(UIHandles.ZMax, 'string'));
ds.ZStep = eval(get(UIHandles.ZStep, 'string'));

%%
%%  Source & Detector Data
%%
ds.SrcXPos = eval(get(UIHandles.SrcXPos, 'string'));
ds.SrcYPos = eval(get(UIHandles.SrcYPos, 'string'));
ds.DetXPos = eval(get(UIHandles.DetXPos, 'string'));
ds.DetYPos = eval(get(UIHandles.DetYPos, 'string'));
ds.SensorError = eval(get(UIHandles.SensorError, 'string'));
ds.ModFreq = eval(get(UIHandles.ModFreq, 'string'));

%%
%% Medium paramters
%%
ds.idxRefr = eval(get(UIHandles.idxRefr, 'string'));
ds.g = eval(get(UIHandles.g, 'string'));
ds.Mu_s = eval(get(UIHandles.Mu_s, 'string'));
ds.Mu_a = eval(get(UIHandles.Mu_a, 'string'));

if get(UIHandles.InfMedium, 'value')
    ds.Boundary = 'Infinite';
end
if get(UIHandles.ExtrapBnd, 'value')
    ds.Boundary = 'Extrapolated';
end

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


%%
%%  Sphere object(s) parameters
%%
ds.SphereCtr = eval(get(UIHandles.SphereCtr, 'string'));
ds.SphereRad = eval(get(UIHandles.SphereRad, 'string'));
ds.SphereDelta = eval(get(UIHandles.SphereDelta, 'string'));

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

%%
%%  Visualiztion parameters
%%
if get(UIHandles.Image, 'value')
    ds.Visualize = 'image';

else
    ds.Visualize = 'contour';
    ds.nCLines = eval(get(UIHandles.nCLines, 'string'));
end

ds.ZIndices = eval(get(UIHandles.ZIndices, 'string'));
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
