%GENMEASDATA    Generate the measured data.
%
%   dsSlabImg = genmeasdata(dsSlabImg);
%
%   dsSlabImg   The slab image data structure to updated.
%
%
%   GENMEASDATA generates the measured data using the data source and
%   noise model information present in the slab image data structure
%   parameter
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
%  $Log: genmeasdata.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:14  rickg
%  Matlab Source
%
%  Revision 2.2  1999/02/05 20:39:28  rjg
%  Correctly handles extracting number of wavelengths from mu_a
%  Handles both spheres and blocks (multiple)
%  Calculates the total variance of the noise for appropriate weighting
%  Added TotalVar field to structure
%  No need for update flag for noise wieghting, removed.
%  Added code to added vector norm weighted noise (Eric usual manner
%  for specifying SNR).  Does not correctly handle multiple wavelengths yet.
%
%  Revision 2.1  1998/09/09 15:12:21  rjg
%  Corrected scaling for detector noise to be relative to the unpurturbed
%  scattered field.  Not significant unless two or more noise types were used.
%
%  Revision 2.0  1998/08/20 18:58:22  rjg
%  *** empty log message ***
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function dsSlabImg = genmeasdata(dsSlabImg);
%%
%%  Generate measured data
%%

switch dsSlabImg.DataSource

case 'Matlab Variable' 
    %%
    %%  Matlab variable data should be a matrix with 2 columns, the first ...
    %%  column should contain the total fluence measurement and the second ...
    %%  column should contain the incident fluence level.
    %%
    Fluence = eval(dsSlabImg.MatlabVarName);
    dsSlabImg.Phi_Total = Fluence(:,1);
    dsSlabImg.Phi_Inc = Fluence(:,2);
    dsSlabImg.Phi_Scat = dsSlabImg.Phi_Total - dsSlabImg.Phi_Inc;
    
case 'Born-1'
    %%
    %%  Check to make sure the number of mu_a parameters is the same as the
    %%  number of del mu_a parameters, this is also the number of
    %%  wavelengths.
    %%
    nLambda = size(dsSlabImg.Mu_a, 2);
    if isfield(dsSlabImg, 'SphereCtr')
        nSphere = size(dsSlabImg.SphereCtr, 1);
    else
        nSphere = 0;
    end
    if isfield(dsSlabImg, 'BlockCtr')
        nBlock = size(dsSlabImg.BlockCtr, 1);
    else
        nBlock = 0;
    end
    
    nDMu_a = size(dsSlabImg.Mu_a, 2);
    if nLambda ~= nDMu_a
        error('Incorrect number of del_mu_a parameters, must match mu_a');
    end
    
    %%
    %%  Generate the volume data using the 1st born method
    %%
    nMeas = size(dsSlabImg.A, 1);
    nVoxels = size(dsSlabImg.A, 2);
    dsSlabImg.del_mu_a = zeros(nVoxels, nLambda);
    dsSlabImg.Phi_Scat = zeros(nMeas, nLambda);
    for iLambda = 1:nLambda
        for iSphere = 1:nSphere
            tmp = gensphere1(dsSlabImg.CompVol, ...
                dsSlabImg.SphereCtr(iSphere,:), ...
                dsSlabImg.SphereRad(iSphere, :), ...
                dsSlabImg.SphereDelta(iSphere, iLambda));
            dsSlabImg.del_mu_a(:, iLambda) = dsSlabImg.del_mu_a(:, iLambda) ...
                + tmp(:);
        end
        for iBlock = 1:nBlock
            tmp = genblock(dsSlabImg.CompVol, ...
                dsSlabImg.BlockCtr(iBlock,:), ...
                dsSlabImg.BlockDims(iBlock, :), ...
                dsSlabImg.BlockDelta(iBlock, iLambda));
            dsSlabImg.del_mu_a(:, iLambda) = dsSlabImg.del_mu_a(:, iLambda) ...
                + tmp(:);
        end
        
        dsSlabImg.Phi_Scat(:, iLambda) = dsSlabImg.A(:,:,iLambda) * ...
            dsSlabImg.del_mu_a(:, iLambda);
    end
    dsSlabImg.Phi_Total = dsSlabImg.Phi_Inc + dsSlabImg.Phi_Scat;

    
otherwise
    error('Unknown data source')
end

%%
%%  Calculate the incident to purturbation ratio
%%
dsSlabImg.IPR = abs(dsSlabImg.Phi_Inc) ./ abs(dsSlabImg.Phi_Scat);

%%
%%  Copy in the non-noise scattered field into the noise modified
%%  scattered field.
%%
dsSlabImg.Phi_ScatN = dsSlabImg.Phi_Scat;

dsSlabImg.TotalVar = zeros(size(dsSlabImg.Phi_Scat));

%%
%%  Add source side noise relative to the total field if selected
%%
if dsSlabImg.SrcSNRflag
    dsSlabImg.SrcNoiseSTD  = abs(dsSlabImg.Phi_Total) * ...
        (10 ^ (-1 * dsSlabImg.SrcSNR / 20));
    dsSlabImg.TotalVar = dsSlabImg.TotalVar + dsSlabImg.SrcNoiseSTD .^ 2;
    dsSlabImg.SrcNoise = randn(size(dsSlabImg.Phi_Total)) .* ...
        dsSlabImg.SrcNoiseSTD;
    dsSlabImg.Phi_ScatN = dsSlabImg.Phi_ScatN + dsSlabImg.SrcNoise;
    fprintf('Max source noise std %e\n', max(dsSlabImg.SrcNoiseSTD));
    fprintf('Min source noise std %e\n\n', min(dsSlabImg.SrcNoiseSTD));
end

%%
%%  Add detector side noise relative to the scattered field if selected.
%%
if dsSlabImg.DetSNRflag
    dsSlabImg.DetNoiseSTD = max(abs(dsSlabImg.Phi_Scat)) * ...
        (10 ^ (-1 * dsSlabImg.DetSNR / 20));
    dsSlabImg.TotalVar = dsSlabImg.TotalVar + dsSlabImg.DetNoiseSTD .^ 2;
    dsSlabImg.DetNoise = randn(size(dsSlabImg.Phi_Scat)) * ...
        diag(dsSlabImg.DetNoiseSTD);
    dsSlabImg.Phi_ScatN = dsSlabImg.Phi_ScatN + dsSlabImg.DetNoise;
    fprintf('Detector noise std %e\n\n', dsSlabImg.DetNoiseSTD);
end


%%
%%  Add scattered ratio noise relative to the scattered field if selected
%%  The noise variance at each detector is relative to the scattered
%%  field at the detector.
%%
if dsSlabImg.ScatSNRflag
    dsSlabImg.ScatNoiseSTD = abs(dsSlabImg.Phi_Scat) * ...
        (10 ^ (-1 * dsSlabImg.ScatSNR / 20));
    dsSlabImg.TotalVar = dsSlabImg.TotalVar + dsSlabImg.ScatNoiseSTD .^ 2;
    dsSlabImg.ScatNoise = randn(size(dsSlabImg.Phi_Scat)) .* ...
        dsSlabImg.ScatNoiseSTD;
    dsSlabImg.Phi_ScatN = dsSlabImg.Phi_ScatN + dsSlabImg.ScatNoise;
    fprintf('Max scattered ratio noise std %e\n', max(dsSlabImg.ScatNoiseSTD));
    fprintf('Min scattered noise std %e\n\n', min(dsSlabImg.ScatNoiseSTD));
end

%%
%%  Measured vector norm relative noise
%%  NEED TO MAKE THIS HANDLE MULTIPLE WAVELENGTHS
%%
if dsSlabImg.VecNormSNRflag
    fprint('THIS DOES NOT HANDLE MULTIPLE WAVELENGTHS YET!!!')
    dsSlabImg.VecNormSTD = norm(dsSlabImg.Phi_Scat) / ...
        sqrt((length(dsSlabImg.Phi_Scat) * 10^(dsSlabImg.VecNormSNR / 10)));
    dsSlabImg.TotalVar = dsSlabImg.TotalVar + dsSlabImg.VecNormSTD .^ 2;
    dsSlabImg.VecNormNoise = randn(size(dsSlabImg.Phi_Scat)) .* ...
        dsSlabImg.VecNormSTD;
    dsSlabImg.Phi_ScatN = dsSlabImg.Phi_ScatN + dsSlabImg.VecNormNoise;
    fprintf('Measured data norm relative noise std %e\n', ...
        max(dsSlabImg.VecNormSTD));
end

%%
%%  Compute the weighted system for to whiten the noise
%%
dsSlabImg.A_w = zeros(size(dsSlabImg.A));
dsSlabImg.Phi_ScatN_w = zeros(size(dsSlabImg.Phi_ScatN));

if dsSlabImg.ScatSNRflag | dsSlabImg.SrcSNRflag
    disp('Weighting for non-white noise');
    dsSlabImg.w = sqrt(dsSlabImg.TotalVar) .^ -1;
    nr = size(dsSlabImg.A,1);
    for j = 1:nLambda
        for i=1:nr
            dsSlabImg.A_w(i,:, j) = dsSlabImg.A(i,:,j) * dsSlabImg.w(i,j);
        end
    end
    dsSlabImg.Phi_ScatN_w = dsSlabImg.w .* dsSlabImg.Phi_ScatN;

else
    disp('No weighting applied');
    dsSlabImg.w = ones(size(dsSlabImg.Phi_ScatN));
    dsSlabImg.A_w = dsSlabImg.A;
    dsSlabImg.Phi_ScatN_w = dsSlabImg.Phi_ScatN;
end

dsSlabImg.flgNeedFullSVD = 1;
dsSlabImg.flgNeedEconSVD = 1;
