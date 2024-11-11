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
%  $Date: 2004/01/03 08:26:15 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: setall.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:15  rickg
%  Matlab Source
%
%  Revision 2.3  1999/02/05 20:47:31  rjg
%  Handles conditional setting of object parameters.
%
%  Revision 2.2  1998/08/12 19:02:20  rjg
%  Added forgotten setting of the visualization plane.
%
%  Revision 2.1  1998/08/07 21:33:03  rjg
%  Change ZIndices to PlaneIndices to reflect the ability to slice in all
%  three dimensions.
%
%  Revision 2.0  1998/08/05 18:40:16  rjg
%  Handles CompVol structure of SlabImage data structure.
%  Added Z pos for source and detctors.
%  Added amplitude for sources.
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

set(UIHandles.XMin, 'string', num2str(min(ds.CompVol.X)));
set(UIHandles.XMax, 'string', num2str(max(ds.CompVol.X)));
set(UIHandles.XStep, 'string', num2str(ds.CompVol.XStep));
set(UIHandles.YMin, 'string', num2str(min(ds.CompVol.Y)));
set(UIHandles.YMax, 'string', num2str(max(ds.CompVol.Y)));
set(UIHandles.YStep, 'string', num2str(ds.CompVol.YStep));
set(UIHandles.ZMin, 'string', num2str(min(ds.CompVol.Z)));
set(UIHandles.ZMax, 'string', num2str(max(ds.CompVol.Z)));
set(UIHandles.ZStep, 'string', num2str(ds.CompVol.ZStep));

%%
%%  Source & Detector Data
%%
set(UIHandles.SrcXPos, 'string', uvec2str(ds.SrcPos.X));
set(UIHandles.SrcYPos, 'string', uvec2str(ds.SrcPos.Y));
set(UIHandles.SrcZPos, 'string', vec2str(ds.SrcPos.Z));
set(UIHandles.SrcAmp, 'string', vec2str(ds.SrcAmp));
set(UIHandles.DetXPos, 'string', uvec2str(ds.DetPos.X));
set(UIHandles.DetYPos, 'string', uvec2str(ds.DetPos.Y));
set(UIHandles.DetZPos, 'string', vec2str(ds.DetPos.Z));
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
%%
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

if isfield(ds, 'VecNormSNRflag')
    set(UIHandles.VecNormSNRflag, 'value', ds.VecNormSNRflag);
end
if isfield(ds, 'VecNormSNR')
    set(UIHandles.VecNormSNR, 'string', num2str(ds.VecNormSNR));
end

if isfield(ds, 'SphereCtr')
    set(UIHandles.SphereCtr, 'string', vec2str(ds.SphereCtr));
end
if isfield(ds, 'SphereRad')
    set(UIHandles.SphereRad, 'string', vec2str(ds.SphereRad));
end
if isfield(ds, 'SphereDelta')
    set(UIHandles.SphereDelta, 'string', vec2str(ds.SphereDelta));
end

if isfield(ds, 'BlockCtr')
    set(UIHandles.BlockCtr, 'string', vec2str(ds.BlockCtr));
end
if isfield(ds, 'BlockDims')
    set(UIHandles.BlockDims, 'string', vec2str(ds.BlockDims));
end
if isfield(ds, 'BlockDelta')
    set(UIHandles.BlockDelta, 'string', vec2str(ds.BlockDelta));
end

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
rbVisPlane(ds.VisPlane);
set(UIHandles.PlaneIndices, 'string', vec2str(ds.PlaneIndices));
set(UIHandles.LayoutVector, 'string', vec2str(ds.LayoutVector));

rbVisualize(ds.Visualize)
if strcmp(ds.Visualize, 'contour')
    set(UIHandles.nCLines, 'string', int2str(ds.nCLines));
end

rbColorMap(ds.CMap);
rbColorRange(ds.CRange);
if strcmp(ds.CRange, 'fixed')
    set(UIHandles.CRangeVal, 'string', vec2str(ds.CRangeVal));
end
