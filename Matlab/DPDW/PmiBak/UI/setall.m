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
%  $Date: 2004/01/03 08:26:42 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: setall.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:42  rickg
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
%%  Forward Model Parameters
%%
if isfield(ds, 'Fwd')
    %%
    %%  Medium Parametes
    %%
    if isfield(ds.Fwd, 'nu')
        set(UIHandles.Fwd_idxRefr, 'string',  vec2str(3.0E10 ./ ds.Fwd.nu));
    else
        set(UIHandles.Fwd_idxRefr, 'string',  vec2str(3.0E10 ./ ds.Fwd.v));
    end
    set(UIHandles.Fwd_g, 'string', vec2str(ds.Fwd.g));
    set(UIHandles.Fwd_Mu_s, 'string', vec2str(ds.Fwd.Mu_sp ./ (1 - ds.Fwd.g)));
    set(UIHandles.Fwd_Mu_a, 'string', vec2str(ds.Fwd.Mu_a));
    rbFwdBoundary(ds.Fwd.Boundary);

    %%
    %%  Computation volume
    %%
    set(UIHandles.Fwd_XMin, 'string', num2str(min(ds.Fwd.CompVol.X)));
    set(UIHandles.Fwd_XMax, 'string', num2str(max(ds.Fwd.CompVol.X)));
    set(UIHandles.Fwd_XStep, 'string', num2str(ds.Fwd.CompVol.XStep));
    set(UIHandles.Fwd_YMin, 'string', num2str(min(ds.Fwd.CompVol.Y)));
    set(UIHandles.Fwd_YMax, 'string', num2str(max(ds.Fwd.CompVol.Y)));
    set(UIHandles.Fwd_YStep, 'string', num2str(ds.Fwd.CompVol.YStep));
    set(UIHandles.Fwd_ZMin, 'string', num2str(min(ds.Fwd.CompVol.Z)));
    set(UIHandles.Fwd_ZMax, 'string', num2str(max(ds.Fwd.CompVol.Z)));
    set(UIHandles.Fwd_ZStep, 'string', num2str(ds.Fwd.CompVol.ZStep));

    %%
    %%  Source & Detector Data
    %%
    set(UIHandles.Fwd_SrcXPos, 'string', uvec2str(ds.Fwd.SrcPos.X));
    set(UIHandles.Fwd_SrcYPos, 'string', uvec2str(ds.Fwd.SrcPos.Y));
    set(UIHandles.Fwd_SrcZPos, 'string', vec2str(ds.Fwd.SrcPos.Z));
    set(UIHandles.Fwd_SrcAmp, 'string', vec2str(ds.Fwd.SrcAmp));
    set(UIHandles.Fwd_DetXPos, 'string', uvec2str(ds.Fwd.DetPos.X));
    set(UIHandles.Fwd_DetYPos, 'string', uvec2str(ds.Fwd.DetPos.Y));
    set(UIHandles.Fwd_DetZPos, 'string', vec2str(ds.Fwd.DetPos.Z));
    set(UIHandles.Fwd_SensorError, 'string', num2str(ds.Fwd.SensorError));
    set(UIHandles.Fwd_ModFreq, 'string', uvec2str(ds.Fwd.ModFreq));

    %%
    %%  Forward model method
    %%
    rbFwdMethod(ds.Fwd.Method.Type);

    if strcmp(ds.Fwd.Method.Type, 'Born')
        set(UIHandles.Fwd_Order, 'string', num2str(ds.Fwd.Method.Order));
    end

    if strcmp(ds.Fwd.Method.Type, 'Rytov')
        set(UIHandles.Fwd_Order, 'string', num2str(ds.Fwd.Method.Order));
    end

    if strcmp(ds.Fwd.Method.Type, 'Spherical')
        set(UIHandles.Fwd_Order, 'string', num2str(ds.Fwd.Method.Order));
    end
end

%%
%%  Inverse Model Parameters
%%
if isfield(ds, 'Inv')
    %%
    %%  Medium Parameters
    %%
    if isfield(ds.Inv, 'nu')
        set(UIHandles.Inv_idxRefr, 'string',  vec2str(3.0E10 ./ ds.Inv.nu));
    else
        set(UIHandles.Inv_idxRefr, 'string',  vec2str(3.0E10 ./ ds.Inv.v));
    end
    set(UIHandles.Inv_g, 'string', vec2str(ds.Inv.g));
    set(UIHandles.Inv_Mu_s, 'string', vec2str(ds.Inv.Mu_sp ./ (1 - ds.Inv.g)));
    set(UIHandles.Inv_Mu_a, 'string', vec2str(ds.Inv.Mu_a));
    rbInvBoundary(ds.Inv.Boundary);

    %%
    %%  Computation volume
    %%
    set(UIHandles.Inv_XMin, 'string', num2str(min(ds.Inv.CompVol.X)));
    set(UIHandles.Inv_XMax, 'string', num2str(max(ds.Inv.CompVol.X)));
    set(UIHandles.Inv_XStep, 'string', num2str(ds.Inv.CompVol.XStep));
    set(UIHandles.Inv_YMin, 'string', num2str(min(ds.Inv.CompVol.Y)));
    set(UIHandles.Inv_YMax, 'string', num2str(max(ds.Inv.CompVol.Y)));
    set(UIHandles.Inv_YStep, 'string', num2str(ds.Inv.CompVol.YStep));
    set(UIHandles.Inv_ZMin, 'string', num2str(min(ds.Inv.CompVol.Z)));
    set(UIHandles.Inv_ZMax, 'string', num2str(max(ds.Inv.CompVol.Z)));
    set(UIHandles.Inv_ZStep, 'string', num2str(ds.Inv.CompVol.ZStep));

    %%
    %%  Source & Detector Data
    %%
    set(UIHandles.Inv_SrcXPos, 'string', uvec2str(ds.Inv.SrcPos.X));
    set(UIHandles.Inv_SrcYPos, 'string', uvec2str(ds.Inv.SrcPos.Y));
    set(UIHandles.Inv_SrcZPos, 'string', vec2str(ds.Inv.SrcPos.Z));
    set(UIHandles.Inv_SrcAmp, 'string', vec2str(ds.Inv.SrcAmp));
    set(UIHandles.Inv_DetXPos, 'string', uvec2str(ds.Inv.DetPos.X));
    set(UIHandles.Inv_DetYPos, 'string', uvec2str(ds.Inv.DetPos.Y));
    set(UIHandles.Inv_DetZPos, 'string', vec2str(ds.Inv.DetPos.Z));
    set(UIHandles.Inv_SensorError, 'string', num2str(ds.Inv.SensorError));
    set(UIHandles.Inv_ModFreq, 'string', uvec2str(ds.Inv.ModFreq));

    %%
    %%  Forward model method
    %%
    rbInvMethod(ds.Inv.Method);
end

%%
%%  Noise Model Parameters
%%
if isfield(ds, 'Noise')
    %%
    %%  Noise level controls
    %%
    if ds.Noise.SrcSNRflag
        set(UIHandles.SrcSNRflag, 'value', 1);
        set(UIHandles.SrcSNR, 'string', num2str(ds.Noise.SrcSNR));
    else
        set(UIHandles.SrcSNRflag, 'value', 0);
        if isfield(ds.Noise, 'SrcSNR')
            set(UIHandles.SrcSNR, 'string', num2str(ds.Noise.SrcSNR));
        end
    end    
    if ds.Noise.DetSNRflag
        set(UIHandles.DetSNRflag, 'value', 1);
        set(UIHandles.DetSNR, 'string', num2str(ds.Noise.DetSNR));
    else
        set(UIHandles.DetSNRflag, 'value', 0);
        if isfield(ds.Noise, 'DetSNR')
            set(UIHandles.DetSNR, 'string', num2str(ds.Noise.DetSNR));
        end
    end

    if ds.Noise.ScatSNRflag
        set(UIHandles.ScatSNRflag, 'value', 1);
        set(UIHandles.ScatSNR, 'string', num2str(ds.Noise.ScatSNR));
    else
        set(UIHandles.ScatSNRflag, 'value', 0);
        if isfield(ds.Noise, 'ScatSNR')
            set(UIHandles.ScatSNR, 'string', num2str(ds.Noise.ScatSNR));
        end
    end    

    if isfield(ds.Noise, 'VecNormSNRflag')
        set(UIHandles.VecNormSNRflag, 'value', ds.Noise.VecNormSNRflag);
    end
    if isfield(ds.Noise, 'VecNormSNR')
        set(UIHandles.VecNormSNR, 'string', num2str(ds.Noise.VecNormSNR));
    end
end

%%
%%  Object Model Parameters
%%
if isfield(ds, 'Object')
    if isfield(ds.Object, 'SphereCtr')
        set(UIHandles.SphereCtr, 'string', vec2str(ds.Object.SphereCtr));
    end
    if isfield(ds.Object, 'SphereRad')
        set(UIHandles.SphereRad, 'string', vec2str(ds.Object.SphereRad));
    end
    if isfield(ds.Object, 'SphereDelta')
        set(UIHandles.SphereDelta, 'string', vec2str(ds.Object.SphereDelta));
    end

    if isfield(ds.Object, 'BlockCtr')
        set(UIHandles.BlockCtr, 'string', vec2str(ds.Object.BlockCtr));
    end
    if isfield(ds.Object, 'BlockDims')
        set(UIHandles.BlockDims, 'string', vec2str(ds.Object.BlockDims));
    end
    if isfield(ds.Object, 'BlockDelta')
        set(UIHandles.BlockDelta, 'string', vec2str(ds.Object.BlockDelta));
    end
end

%%
%%  Reoncstruction Parameters
%%
if isfield(ds, 'Recon')
    %%
    %%  Reconstruction algorithm
    %%
    rbRecon(ds.Recon.ReconAlg)
    switch ds.Recon.ReconAlg
        case 'Back Projection'
        case 'Min. Norm'
        case 'ART'
            set(UIHandles.ARTnIter, 'string', num2str(ds.Recon.ARTnIter));
        case 'SIRT'
            set(UIHandles.SIRTnIter, 'string', num2str(ds.Recon.SIRTnIter));
        case 'TSVD'
            set(UIHandles.TSVDnSV, 'string', num2str(ds.Recon.TSVDnSV));
        case 'MTSVD'
            set(UIHandles.MTSVDnSV, 'string', num2str(ds.Recon.MTSVDnSV));
            set(UIHandles.MTSVDLambda, 'string', ...
                num2str(ds.Recon.MTSVDLambda));
        case 'TCG'
            set(UIHandles.TCGnIter, 'string', num2str(ds.Recon.TCGnIter));
        otherwise
            error(['Unknown reconstruction technique: ' ds.Recon.ReconAlg]);
    end
end

%%
%%  Visualization Parameters
%%
if isfield(ds, 'Visualize')
    %%
    %%  Visualization technique
    %%
    rbVisPlane(ds.Visualize.VisPlane);
    set(UIHandles.PlaneIndices, 'string', vec2str(ds.Visualize.PlaneIndices));
    set(UIHandles.LayoutVector, 'string', vec2str(ds.Visualize.LayoutVector));

    rbVisualize(ds.Visualize.Type)
    if strcmp(ds.Visualize.Type, 'contour')
        set(UIHandles.nCLines, 'string', int2str(ds.Visualize.nCLines));
    end

    rbColormap(ds.Visualize.CMap);
    rbColorRange(ds.Visualize.CRange);
    if strcmp(ds.Visualize.CRange, 'fixed')
        set(UIHandles.CRangeVal, 'string', vec2str(ds.Visualize.CRangeVal));
    end
end
