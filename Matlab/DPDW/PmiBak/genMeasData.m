%GenMeasData    Generate the measured data.
%
%   ds = genMeasData(ds);
%
%   ds          The PMI Imaging data structure to updated.
%
%
%   GenMeasData generates the noiseless measured data using the forward method
%   information present in the PMI imaging data structure.
%
%   Calls: none.
%
%   Bugs: CURRENTLY ONLY HANDLES 1st ORDER FOR BORN CASE.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:31 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: genMeasData.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:31  rickg
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

function ds = genMeasData(ds);
%%
%%  Generate measured data
%%

switch ds.Fwd.Method.Type

case 'Matlab Variable' 
    %%
    %%  Matlab variable data should be a matrix with 2 columns, the first ...
    %%  column should contain the total fluence measurement and the second ...
    %%  column should contain the incident fluence level.
    %%
    Fluence = eval(ds.Fwd.Method.MatlabVarName);
    ds.PhiTotal = Fluence(:,1);
    if ds > 0
        ds.Fwd.PhiInc = Fluence(:,2);
        ds.Fwd.PhiScat = ds.PhiTotal - ds.Fwd.PhiInc;
    end
    
case 'Born'
    %%
    %%  Check to make sure the number of mu_a parameters is the same as the
    %%  number of delMu_a parameters, this is also the number of
    %%  wavelengths.
    %%
    nLambda = size(ds.Fwd.Mu_a, 2);
    if isfield(ds.Object, 'SphereCtr')
        nSphere = size(ds.Object.SphereCtr, 1);
    else
        nSphere = 0;
    end
    if isfield(ds.Object, 'BlockCtr')
        nBlock = size(ds.Object.BlockCtr, 1);
    else
        nBlock = 0;
    end
    
    nDMu_a = size(ds.Fwd.Mu_a, 2);
    if nLambda ~= nDMu_a
        error('Incorrect number of delMu_a parameters, must match mu_a');
    end
    
    %%
    %%  Generate the volume data using the 1st born method
    %%
    nMeas = size(ds.Fwd.A, 1);
    nVoxels = size(ds.Fwd.A, 2);
    ds.Object.delMu_a = zeros(nVoxels, nLambda);
    ds.Fwd.PhiScat = zeros(nMeas, nLambda);
    
    for iLambda = 1:nLambda
        for iSphere = 1:nSphere
            tmp = gensphere1(ds.Fwd.CompVol, ...
                ds.Object.SphereCtr(iSphere,:), ...
                ds.Object.SphereRad(iSphere, :), ...
                ds.Object.SphereDelta(iSphere, iLambda));
            ds.Object.delMu_a(:, iLambda) = ...
                ds.Object.delMu_a(:, iLambda) + tmp(:);
        end
        for iBlock = 1:nBlock
            tmp = genblock(ds.Fwd.CompVol, ...
                ds.Object.BlockCtr(iBlock,:), ...
                ds.Object.BlockDims(iBlock, :), ...
                ds.Object.BlockDelta(iBlock, iLambda));
            ds.Object.delMu_a(:, iLambda) = ...
                ds.Object.delMu_a(:, iLambda) + tmp(:);
        end

        ds.Fwd.PhiScat(:, iLambda) = ...
            ds.Fwd.A(:,:,iLambda) * ds.Object.delMu_a(:, iLambda);
        
    end

    ds.PhiTotal = ds.Fwd.PhiInc + ds.Fwd.PhiScat;

case 'ExtBorn'
    %%
    %%  Check to make sure the number of mu_a parameters is the same as the
    %%  number of delMu_a parameters, this is also the number of
    %%  wavelengths.
    %%
    nLambda = size(ds.Fwd.Mu_a, 2);
    nDMu_a = size(ds.Fwd.Mu_a, 2);
    if nLambda ~= nDMu_a
        error('Incorrect number of Mu_a parameters, must match mu_a');
    end

    %%
    %%  Source modulation frequency and source & detector positions
    %%
    [Xp Yp Zp] = meshgrid(ds.Fwd.SrcPos.X, ds.Fwd.SrcPos.Y, ...
        ds.Fwd.SrcPos.Z-(1/ds.Fwd.Mu_sp));

    nSrc = prod(size(Xp));
    pSrc = [Xp(:) Yp(:) Zp(:)];
    
    [Xp Yp Zp] = meshgrid(ds.Fwd.DetPos.X, ds.Fwd.DetPos.Y, ...
        ds.Fwd.DetPos.Z);
    nDet = prod(size(Xp));
    pDet = [Xp(:) Yp(:) Zp(:)];
   
    nSDPair = nSrc * nDet;
    nFreq = length(ds.Fwd.ModFreq);
    nCmplx = sum(ds.Fwd.ModFreq > 0);
    nMeas = nSDPair * (nFreq + nCmplx);

    ds.Fwd.PhiScat = zeros(nMeas, nLambda);
    ds.Fwd.PhiInc = zeros(nMeas, nLambda);
    ds.PhiTotal = zeros(nMeas, nLambda);
    nVoxels = length(ds.Fwd.CompVol.X) * length(ds.Fwd.CompVol.Y) * ...
        length(ds.Fwd.CompVol.Z);
    ds.Object.delMu_a = zeros(nVoxels, nLambda);
    if nFreq > 1
        warning(['Multiple frequencies are not currently implemented for ' ...
                'Extended born']);
    end

    %%
    %%  Get the number of spheres & blocks
    %%
    if isfield(ds.Object, 'SphereCtr')
        nSphere = size(ds.Object.SphereCtr, 1);
    else
        nSphere = 0;
    end
    if isfield(ds.Object, 'BlockCtr')
        nBlock = size(ds.Object.BlockCtr, 1);
    else
        nBlock = 0;
    end

    %%
    %%  Calculate the fluence at the detector using the extended born method
    %%  looping over each wavelength
    %%
    for iLambda = 1:nLambda
        for iSphere = 1:nSphere
            tmp = gensphere1(ds.Fwd.CompVol, ...
                ds.Object.SphereCtr(iSphere,:), ...
                ds.Object.SphereRad(iSphere, :), ...
                ds.Object.SphereDelta(iSphere, iLambda));
            ds.Object.delMu_a(:, iLambda) = ...
                ds.Object.delMu_a(:, iLambda) + tmp(:);
        end
        for iBlock = 1:nBlock
            tmp = genblock(ds.Fwd.CompVol, ...
                ds.Object.BlockCtr(iBlock,:), ...
                ds.Object.BlockDims(iBlock, :), ...
                ds.Object.BlockDelta(iBlock, iLambda));
            ds.Object.delMu_a(:, iLambda) = ...
                ds.Object.delMu_a(:, iLambda) + tmp(:);
        end

        mu_sp = ds.Fwd.Mu_sp(iLambda);
        mu_a = ds.Fwd.Mu_a(iLambda);
        v = ds.Fwd.v(iLambda);
        idxRefr = ds.Fwd.idxRefr(iLambda);
        f = ds.Fwd.ModFreq * 1E6;

        %%
        %%  Select the appropriate method for the boundary condition
        %%
        if strcmp(ds.Fwd.Boundary, 'Extrapolated');
            [PhiTotal PhiInc] = ...
                DPDWEBornZB(ds.Fwd.CompVol, mu_sp, mu_a, ...
                ds.Object.delMu_a(:,iLambda) , v, ....
                idxRefr, f, pSrc, pDet, ds.Debug);
        else
            [PhiTotal PhiInc] = ...
                DPDWEBornNB(ds.Fwd.CompVol, mu_sp, mu_a, ...
                ds.Object.delMu_a(:,iLambda) , v, ....
                idxRefr, f, pSrc, pDet, ds.Debug);
        end
        
        if ds.Fwd.ModFreq > 0
            ds.PhiTotal(:, iLambda) = [real(PhiTotal); imag(PhiTotal)];
            ds.Fwd.PhiInc(:, iLambda) = [real(PhiInc); imag(PhiInc)];            
        else
            ds.PhiTotal(:, iLambda) = real(PhiTotal);
            ds.Fwd.PhiInc(:, iLambda) = real(PhiInc);            
        end
    end
    ds.Fwd.PhiScat = ds.PhiTotal - ds.Fwd.PhiInc;

    
case 'FDFD'
    %%
    %%  Check to make sure the number of mu_a parameters is the same as the
    %%  number of delMu_a parameters, this is also the number of
    %%  wavelengths.
    %%
    nLambda = size(ds.Fwd.Mu_a, 2);
    nDMu_a = size(ds.Fwd.Mu_a, 2);
    if nLambda ~= nDMu_a
        error('Incorrect number of Mu_a parameters, must match mu_a');
    end
    %%
    %%  This extrapolated boundary condition is from:
    %%    Boundary conditions for the diffusion equation in radiative transfer
    %%    Haskell et. al.,  J. Opt. Soc. Am - A   Vol. 11, No. 10,  Oct 1994
    %%    pg 2727 - 2741
    %%
    %%
    %%  Reff is a linear fit to the table on p. 2731
    %%
    Reff = (0.493-0.431) / (1.40 - 1.33) * ds.Fwd.idxRefr - 0.747;
    zBnd = 2/3 * (1 + Reff) / (1 - Reff) / ds.Fwd.Mu_sp;
    if ds.Debug
        fprintf('Extrapolated boundary = %f cm\n', zBnd);
    end

    %%
    %%  Adujust the computational volume for the boundary.
    %%  Assuming a negative Z medium
    %%
    if strcmp(ds.Fwd.Boundary, 'Extrapolated')
        CVShift = - max(ds.Fwd.CompVol.Z) + zBnd;
        ds.Fwd.CompVol.Z = ds.Fwd.CompVol.Z + CVShift;
        if ds.Debug
            fprintf('Z Domain computational volume shifted %f cm\n', CVShift);
        end
    end
    
    %%
    %%  Source modulation frequency and source & detector positions
    %%
    [Xp Yp Zp] = meshgrid(ds.Fwd.SrcPos.X, ds.Fwd.SrcPos.Y, ...
        ds.Fwd.SrcPos.Z-(1/ds.Fwd.Mu_sp));

    nSrc = prod(size(Xp));
    pSrc = [Xp(:) Yp(:) Zp(:)];
    
    [Xp Yp Zp] = meshgrid(ds.Fwd.DetPos.X, ds.Fwd.DetPos.Y, ...
        ds.Fwd.DetPos.Z);
    nDet = prod(size(Xp));
    pDet = [Xp(:) Yp(:) Zp(:)];
   
    nSDPair = nSrc * nDet;
    nFreq = length(ds.Fwd.ModFreq);
    nCmplx = sum(ds.Fwd.ModFreq > 0);
    nMeas = nSDPair * (nFreq + nCmplx);

    ds.Fwd.PhiScat = zeros(nMeas, nLambda);
    ds.Fwd.PhiInc = zeros(nMeas, nLambda);
    ds.PhiTotal = zeros(nMeas, nLambda);
    nVoxels = length(ds.Fwd.CompVol.X) * length(ds.Fwd.CompVol.Y) * ...
        length(ds.Fwd.CompVol.Z);
    ds.Object.delMu_a = zeros(nVoxels, nLambda);
    if nFreq > 1
        warning(['Multiple frequencies are not currently implemented for ' ...
                'FDFD']);
    end

    %%
    %%  Get the number of spheres & blocks
    %%
    if isfield(ds.Object, 'SphereCtr')
        nSphere = size(ds.Object.SphereCtr, 1);
    else
        nSphere = 0;
    end
    if isfield(ds.Object, 'BlockCtr')
        nBlock = size(ds.Object.BlockCtr, 1);
    else
        nBlock = 0;
    end

    %%
    %%  Calculate the fluence at the detector using the extended born method
    %%  looping over each wavelength
    %%
    for iLambda = 1:nLambda
        for iSphere = 1:nSphere
            tmp = gensphere1(ds.Fwd.CompVol, ...
                ds.Object.SphereCtr(iSphere,:), ...
                ds.Object.SphereRad(iSphere, :), ...
                ds.Object.SphereDelta(iSphere, iLambda));
            ds.Object.delMu_a(:, iLambda) = ...
                ds.Object.delMu_a(:, iLambda) + tmp(:);
        end
        for iBlock = 1:nBlock
            tmp = genblock(ds.Fwd.CompVol, ...
                ds.Object.BlockCtr(iBlock,:), ...
                ds.Object.BlockDims(iBlock, :), ...
                ds.Object.BlockDelta(iBlock, iLambda));
            ds.Object.delMu_a(:, iLambda) = ...
                ds.Object.delMu_a(:, iLambda) + tmp(:);
        end

        mu_sp = ds.Fwd.Mu_sp(iLambda);
        mu_a = ds.Fwd.Mu_a(iLambda);
        v = ds.Fwd.v(iLambda);
        idxRefr = ds.Fwd.idxRefr(iLambda);
        f = ds.Fwd.ModFreq * 1E6;

        %%
        %%  Select the appropriate method for the boundary condition
        %%
        if strcmp(ds.Fwd.Boundary, 'Extrapolated')
            [PhiScat PhiInc] = ...
                DPDWFDJacZB(ds.Fwd.CompVol, mu_sp, mu_a, ...
                ds.Object.delMu_a(:,iLambda) , v, ....
                f, pSrc, ones(size(pSrc,1),1), pDet, ...
                    ones(size(pSrc,1),1), ds.Debug);
        else
                [PhiScat PhiInc] = ...
                    DPDWFDJacNB(ds.Fwd.CompVol, mu_sp, mu_a, ...
                    ds.Object.delMu_a(:,iLambda) , v, ....
                    f, pSrc, ones(size(pSrc,1),1), pDet, ...
                    ones(size(pSrc,1),1), ds.Debug);
            end

        if ds.Fwd.ModFreq > 0
            ds.Fwd.PhiScat(:, iLambda) = [real(PhiScat); imag(PhiScat)];
            ds.Fwd.PhiInc(:, iLambda) = [real(PhiInc); imag(PhiInc)];
        else
            ds.Fwd.PhiScat(:, iLambda) = real(PhiScat);
            ds.Fwd.PhiInc(:, iLambda) = real(PhiInc);            
        end
    end
    ds.PhiTotal = ds.Fwd.PhiScat + ds.Fwd.PhiInc;

case 'Spherical'
    %%
    %%  Check to make sure the number of mu_a parameters is the same as the
    %%  number of delMu_a parameters, this is also the number of
    %%  wavelengths.
    %%
    nLambda = size(ds.Fwd.Mu_a, 2);
    if isfield(ds.Object, 'SphereCtr')
        nSphere = size(ds.Object.SphereCtr, 1);
        if nSphere > 1
            fprintf(['WARNING: Spherical harmonic solution for' ...
                    ' multiple spheres is\n']);
            fprintf(['only a simple sum approximation of the' ...
                    ' individual scatterd fields\n']);
        end
    else
        nSphere = 0;
    end
    if isfield(ds.Object, 'BlockCtr')
        error(['Spherical harmonic solution can only handle spherical' ...
                ' objects']);
    end
    %%
    %%  Source modulation frequency and source & detector positions
    %%
    [Xp Yp Zp] = meshgrid(ds.Fwd.SrcPos.X, ds.Fwd.SrcPos.Y, ...
        ds.Fwd.SrcPos.Z-(1/ds.Fwd.Mu_sp));
    nSrc = prod(size(Xp));
    pSrc = [Xp(:) Yp(:) Zp(:)];

    [Xp Yp Zp] = meshgrid(ds.Fwd.DetPos.X, ds.Fwd.DetPos.Y, ...
        ds.Fwd.DetPos.Z);
    nDet = prod(size(Xp));
    pDet = [Xp(:) Yp(:) Zp(:)];
    
    nDMu_a = size(ds.Fwd.Mu_a, 2);
    if nLambda ~= nDMu_a
        error('Incorrect number of delMu_a parameters, must match mu_a');
    end
    nSrc = size(pSrc, 1);
    nDet = size(pDet, 1);
    nSDPair = nSrc * nDet;
    nFreq = length(ds.Fwd.ModFreq);
    nCmplx = sum(ds.Fwd.ModFreq > 0);
    nR = nSDPair * (nFreq + nCmplx);
    ds.Fwd.PhiScat = zeros(nR, nLambda);
    ds.Fwd.PhiInc = zeros(nR, nLambda);

    %%
    %%  Compute the infinite medium solution for each wavelength and
    %%  frequency
    %%
    if strcmp(ds.Fwd.Boundary, 'Infinite')
        for iLambda = 1:nLambda
            opBack.mu_sp = ds.Fwd.Mu_sp(iLambda);
            opBack.mu_a = ds.Fwd.Mu_a(iLambda);
            opSphere.mu_sp = ds.Fwd.Mu_sp(iLambda);
            idxRow =  1;
            for iFreq = 1:nFreq
                w = 2 * pi * ds.Fwd.ModFreq(iFreq) * 1E6;

                PhiScat = zeros(nSDPair,1);
                for iSphere = 1:nSphere
                    opSphere.mu_a = ds.Fwd.Mu_a(iLambda) + ...
                        ds.Object.SphereDelta(iLambda);

                    %%
                    %%  Translate origin to center of sphere.
                    %%
                    tpSrc = pSrc - ...
                        repmat(ds.Object.SphereCtr(iSphere,:), nSrc, 1);
                    tpDet = pDet - ...
                        repmat(ds.Object.SphereCtr(iSphere,:), nDet, 1);
                    
                    %%
                    %%  Calculate scattered field from current object
                    %%
                    [TmpScat PhiInc] = dpdw_sphere_nb(tpSrc, tpDet, w, ...
                        ds.Fwd.v, opBack, opSphere, ...
                        ds.Object.SphereRad(iSphere), ...
                        ds.Fwd.Method.Order, ds.Debug);
                    PhiScat = PhiScat + TmpScat;
                end

                %%
                %%  Fill in scattered field data
                %%
                ds.Fwd.PhiScat(idxRow:idxRow+nSDPair-1, iLambda) = ...
                    real(PhiScat);
                ds.Fwd.PhiInc(idxRow:idxRow+nSDPair-1, iLambda) = ...
                    real(PhiInc);
                idxRow = idxRow + nSDPair;
                if w > 0                
                    ds.Fwd.PhiScat(idxRow:idxRow+nSDPair-1, iLambda) = ...
                        imag(PhiScat);
                    ds.Fwd.PhiInc(idxRow:idxRow+nSDPair-1, iLambda) = ...
                        imag(PhiInc);
                    idxRow = idxRow + nSDPair;
                end
            end
        end
    
                
    %%
    %%  Compute the extraploted boundary  solution for each wavelength
    %%  and frequency
    %%
    else
    
    end
    ds.PhiTotal = ds.Fwd.PhiInc + ds.Fwd.PhiScat;    

otherwise
    error(['Unknown forward method: ' ds.Fwd.Method.Type])
end

%%
%%  Calculate the incident to purturbation ratio
%%
if ds.Debug > 0
    ds.Fwd.IPR = abs(ds.Fwd.PhiInc) ./ abs(ds.Fwd.PhiScat);
end
