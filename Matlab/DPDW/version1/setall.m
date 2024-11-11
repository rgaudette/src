%SETALL         Set all of the system parameter in the Slab Image GUI.
%
%   getall(stSlabImg, hFig)
%
%   stSlabImg   The structure containing all of the Slab Image parameters.
%
%   hFig        The handle of the GUI figure.
%
%   SETALL setall of the modifiable values in the GUI to the values present
%   in the structure stSlabImg.
%
%   Calls: rbBoundary, rbDataSource, rbRecon, vec2str, uvec2str.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:58 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: setall.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:58  rickg
%  Matlab Source
%
%  Revision 1.5  1998/07/30 20:02:56  rjg
%  Removed SIdefines codes, uses string now.
%  Parameters for all three noise models
%  Parameters for TCG
%
%  Revision 1.4  1998/06/05 17:39:13  rjg
%  Uniform vector, vectors and scalar are now handled within the (u)vec2str
%  functions
%
%  Revision 1.3  1998/06/03 16:45:31  rjg
%  Uses SIdefines codes
%  Medium parameters can now be vectors for multiple wavelengths
%  SphereDelta can now be a vector for multple spheres
%  MTSVD implementation
%
%  Revision 1.2  1998/04/29 15:17:16  rjg
%  Added visualization techniques members and comments.
%
%  Revision 1.1  1998/04/28 20:33:08  rjg
%  Initial revision
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function setall(ds, hFig)

UIHandles = get(hFig, 'UserData');
set(0, 'CurrentFigure', hFig);

%%
%%  Computation volume
%%
set(UIHandles.XMin, 'string', num2str(ds.XMin));

set(UIHandles.XMax, 'string', num2str(ds.XMax));
set(UIHandles.XStep, 'string', num2str(ds.XStep));
set(UIHandles.YMin, 'string', num2str(ds.YMin));
set(UIHandles.YMax, 'string', num2str(ds.YMax));
set(UIHandles.YStep, 'string', num2str(ds.YStep));
set(UIHandles.ZMin, 'string', num2str(ds.ZMin));
set(UIHandles.ZMax, 'string', num2str(ds.ZMax));
set(UIHandles.ZStep, 'string', num2str(ds.ZStep));

%%
%%  Source & Detector Data
%%
set(UIHandles.SrcXPos, 'string', uvec2str(ds.SrcXPos));
set(UIHandles.SrcYPos, 'string', uvec2str(ds.SrcYPos));
set(UIHandles.DetXPos, 'string', uvec2str(ds.DetXPos));
set(UIHandles.DetYPos, 'string', uvec2str(ds.DetYPos));
set(UIHandles.SensorError, 'string', num2str(ds.SensorError));
set(UIHandles.ModFreq, 'string', uvec2str(ds.ModFreq));

%%
%%  Medium Parametes
%%
set(UIHandles.idxRefr, 'string', vec2str(ds.idxRefr));
set(UIHandles.g, 'string', vec2str(ds.g));
set(UIHandles.Mu_s, 'string', vec2str(ds.Mu_s));
set(UIHandles.Mu_a, 'string', vec2str(ds.Mu_a));
rbBoundary(ds.Boundary);

%%
%%  Measured data source
%%
rbDataSource(ds.DataSource);

%%
%%  Noise level controls
if ds.SrcSNRflag
    set(UIHandles.SrcSNRflag, 'value', 1);
    set(UIHandles.SrcSNR, 'string', num2str(ds.SrcSNR));
else
    set(UIHandles.SrcSNRflag, 'value', 0);
    if isfield(ds, 'SrcSNR')
        set(UIHandles.SrcSNR, 'string', num2str(ds.SrcSNR));
    end
    
end    
if ds.DetSNRflag
    set(UIHandles.DetSNRflag, 'value', 1);
    set(UIHandles.DetSNR, 'string', num2str(ds.DetSNR));
else
    set(UIHandles.DetSNRflag, 'value', 0);
    if isfield(ds, 'DetSNR')
        set(UIHandles.DetSNR, 'string', num2str(ds.DetSNR));
    end
    
end    

if ds.ScatSNRflag
    set(UIHandles.ScatSNRflag, 'value', 1);
    set(UIHandles.ScatSNR, 'string', num2str(ds.ScatSNR));
else
    set(UIHandles.ScatSNRflag, 'value', 0);
    if isfield(ds, 'ScatSNR')
        set(UIHandles.ScatSNR, 'string', num2str(ds.ScatSNR));
    end
    
end    


set(UIHandles.SphereCtr, 'string', vec2str(ds.SphereCtr));
set(UIHandles.SphereRad, 'string', num2str(ds.SphereRad));

set(UIHandles.SphereDelta, 'string', vec2str(ds.SphereDelta));

%%
%%  Reconstruction algorithm
%%
rbRecon(ds.ReconAlg)
switch ds.ReconAlg
case 'Back Projection'
case 'Min. Norm'
case 'ART'
    set(UIHandles.ARTnIter, 'string', num2str(ds.ARTnIter));
case 'SIRT'
    set(UIHandles.SIRTnIter, 'string', num2str(ds.SIRTnIter));
case 'TSVD'
    set(UIHandles.TSVDnSV, 'string', num2str(ds.TSVDnSV));
case 'MTSVD'
    set(UIHandles.MTSVDnSV, 'string', num2str(ds.MTSVDnSV));
    set(UIHandles.MTSVDLambda, 'string', num2str(ds.MTSVDLambda));
case 'TCG'
    set(UIHandles.TCGnIter, 'string', num2str(ds.TCGnIter));
otherwise
    error(['Unknown reconstruction technique: ' ds.ReconAlg]);
end

%%
%%  Visualization technique
%%
rbVisualize(ds.Visualize)
if strcmp(ds.Visualize, 'contour')
    set(UIHandles.nCLines, 'string', int2str(ds.nCLines));
end

set(UIHandles.ZIndices, 'string', vec2str(ds.ZIndices));
set(UIHandles.LayoutVector, 'string', vec2str(ds.LayoutVector));

rbColorMap(ds.CMap);
rbColorRange(ds.CRange);
if strcmp(ds.CRange, 'fixed')
    set(UIHandles.CRangeVal, 'string', vec2str(ds.CRangeVal));
end
