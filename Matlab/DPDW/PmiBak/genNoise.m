%GenNoise       Generate the noise vector and noise scattered field.
%
%   ds = gennoise(ds);
%
%   ds          The DPDW Imaging data structure to updated.
%
%
%   GenNoise generates instances the selected noise models in the DPDW
%   Imagin data structure.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:31 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: genNoise.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:31  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ds = genNoise(ds);

%%
%%  Copy in the non-noise scattered field into the noise modified
%%  scattered field.
%%
ds.PhiTotalN = ds.PhiTotal;

TotalVar = zeros(size(ds.PhiTotal));
[nMeas nLambda] = size(ds.PhiTotal);

%%
%%  Add source side noise relative to the total field if selected
%%
if ds.Noise.SrcSNRflag
    SrcNoiseSTD  = abs(ds.PhiTotal) * (10 ^ (-1 * ds.Noise.SrcSNR / 20));
    TotalVar = TotalVar + SrcNoiseSTD .^ 2;
    SrcNoise = randn(nMeas, nLambda) .* SrcNoiseSTD;
    ds.PhiTotalN = ds.PhiTotalN + SrcNoise;
    if ds.Debug
        ds.Noise.SrcNoiseSTD = SrcNoiseSTD;
        ds.Noise.SrcNoise = SrcNoise;
        fprintf('Max source noise std %e\n', max(ds.Noise.SrcNoiseSTD));
        fprintf('Min source noise std %e\n\n', min(ds.Noise.SrcNoiseSTD));
    end
end

%%
%%  Add detector side noise relative to the total field if selected.
%%
if ds.Noise.DetSNRflag
    DetNoiseSTD = max(abs(ds.PhiTotal)) * (10 ^ (-1 * ds.Noise.DetSNR / 20));
    
    TotalVar = TotalVar + repmat(DetNoiseSTD .^ 2, nMeas, 1);
    DetNoise = randn(nMeas, nLambda) * diag(DetNoiseSTD);
    ds.PhiTotalN = ds.PhiTotalN + DetNoise;
    if ds.Debug
        ds.Noise.DetNoiseSTD = DetNoiseSTD;
        ds.Noise.DetNoise = DetNoise;
        fprintf('Detector noise std %e\n\n', ds.Noise.DetNoiseSTD);
    end
end


%%
%%  Add scattered ratio noise relative to the peak scattered field if
%%  selected.
%%
if ds.Noise.ScatSNRflag
    ScatNoiseSTD = max(abs(ds.Fwd.PhiScat)) * ...
        (10 ^ (-1 * ds.Noise.ScatSNR / 20));
    TotalVar = TotalVar + repmat(ScatNoiseSTD .^ 2, nMeas, 1);
    ScatNoise = randn(nMeas, nLambda) .* repmat(ScatNoiseSTD, nMeas, 1);
    ds.PhiTotalN = ds.PhiTotalN + ScatNoise;
    if ds.Debug
        ds.Noise.ScatNoiseSTD = ScatNoiseSTD;
        ds.Noise.ScatNoise = ScatNoise;
        fprintf('Scattered relative noise std %e\n', ScatNoiseSTD);
    end
end

%%
%%  Measured vector norm relative noise
%%
if ds.Noise.VecNormSNRflag
    fprint('THIS DOES NOT HANDLE MULTIPLE WAVELENGTHS YET!!!')
    VecNormSTD = norm(ds.Fwd.PhiScat) / ...
        sqrt((length(ds.Fwd.PhiScat) * 10^(ds.Noise.VecNormSNR / 10)));
    TotalVar = TotalVar + VecNormSTD .^ 2;
    VecNormNoise = randn(nMeas, nLambda) .* VecNormSTD;
    ds.PhiTotalN = ds.PhiTotalN + VecNormNoise;
    if ds.Debug
        ds.Noise.VecNormNoiseSTD = VecNormNoiseSTD;
        ds.Noise.VecNormNoise = VecNormNoise;
        fprintf('Measured data norm relative noise std %e\n', max(VecNormSTD));
    end
end

if ds.Debug
    ds.Noise.TotalVar = TotalVar;
end

%%
%%  Compute the weighted system for to whiten the noise
%%
ds.Inv.Aw = zeros(size(ds.Inv.A));
ds.PhiTotalNw = zeros(size(ds.PhiTotalN));
if ds.Noise.SrcSNRflag
    if ds.Debug
        disp('Weighting for non-white noise');
    end
    ds.Noise.w = sqrt(TotalVar) .^ -1;
    ds.Inv.Aw = rowscale(ds.Inv.A, ds.Noise.w);    
    ds.PhiTotalNw = ds.Noise.w .* ds.PhiTotalN;

else
    if ds.Debug
        disp('Uniform noise: No weighting applied');
    end
    ds.Noise.w = ones(size(ds.PhiTotalN));
    ds.Inv.Aw = ds.Inv.A;
    ds.PhiTotalNw = ds.PhiTotalN;
end

ds.Recon.flgNeedFullSVD = 1;
ds.Recon.flgNeedEconSVD = 1;
