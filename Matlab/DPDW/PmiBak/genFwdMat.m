%GenFwdMat      Generate the forward matrix from a DPDW model data structure.
%
%   dsModel = genFwdMat(dsModel, Debug);
%
%   dsModel     The Model data structure to updated.
%
%   Debug       The Debug level to execute.
%
%   GenFwdMat generates the forward matrix and incident field from the
%   parameters present in the slab image data structure.  The results are
%   placed in the data structure as the fields A and PhiInc
%   respectively.  Note that this routine automatically moves the diffuse
%   source positions one mean free path into the medium from the positions
%   supplied in dsModel.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:29 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: genFwdMat.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:29  rickg
%  Matlab Source
%
%  Revision 2.1  1998/08/20 16:22:01  rjg
%  Moved reseting of SVD flags inside function.
%
%  Revision 2.0  1998/08/05 17:58:36  rjg
%  This function handles calculation of the forward matrice(s) and
%  incident fields.  Moved into a function to make cleanup automatic
%  and handle multiple wavelengths.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function dsModel = genFwdMat(dsModel, Debug)

if nargin < 2
    Debug = 0;
end


%%
%%  Source modulation frequency and source & detector positions
%%
if strcmp(dsModel.SrcPos.Type, 'uniform')
    [Xp Yp Zp] = meshgrid(dsModel.SrcPos.X, dsModel.SrcPos.Y, ...
        dsModel.SrcPos.Z);
    nSrc = prod(size(Xp));
    pSrc = [Xp(:) Yp(:) Zp(:)];
else
    nSrc = size(dsModel.SrcPos.Pos, 1);
    pSrc = dsModel.SrcPos.Pos;
end

if strcmp(dsModel.SrcPos.Type, 'uniform')
    [Xp Yp Zp] = meshgrid(dsModel.DetPos.X, dsModel.DetPos.Y, ...
        dsModel.DetPos.Z);
    nDet = prod(size(Xp));
    pDet = [Xp(:) Yp(:) Zp(:)];
else
    nDet = size(dsModel.DetPos.Pos, 1);
    pDet = dsModel.DetPos.Pos;
end

%%
%%  Move the effective source position 1 mean free path into the medium
%%
pSrc(:,3) = pSrc(:,3) - (1/dsModel.Mu_sp);

%%
%%  Get the number of wavelength to compute and replicate the medium
%%  parameters if necessary.
%%
nLambda = length(dsModel.Mu_a);
nIdxRefr = length(dsModel.idxRefr);
if (nIdxRefr ~= 1) & (nIdxRefr ~= nLambda)
    error('Incorrect number of elements for v field, fix index of refraction');
end
if nIdxRefr == 1
    idxRefr = repmat(dsModel.idxRefr, 1, nLambda);
else
    idxRefr = dsModel.idxRefr;
end
nV = length(dsModel.v);
if (nV ~= 1) & (nV ~= nLambda)
    error('Incorrect number of elements for v field, fix index of refraction');
end
if nV == 1
    v = repmat(dsModel.v, 1, nLambda);
else
    v = dsModel.v;
end
nMu_sp = length(dsModel.Mu_sp);
if (nMu_sp ~= 1) & (nMu_sp ~= nLambda)
    error('Incorrect number of elements for Mu_sp field, fix Mu_s or g');
end
if nMu_sp == 1
    Mu_sp = repmat(dsModel.Mu_sp, 1, nLambda);
else
    Mu_sp = dsModel.Mu_sp;
end
    

%%
%%  Preallocate the memory for the forward matrices and incident field
%%
nX = length(dsModel.CompVol.X);
nY = length(dsModel.CompVol.Y);
nZ = length(dsModel.CompVol.Z);
nSDPair = nDet * nSrc;
nFreq = length(dsModel.ModFreq);
nCmplx = sum(dsModel.ModFreq > 0);
nR = nSDPair * (nFreq + nCmplx);
nC = nX * nY *nZ;

dsModel.A = zeros(nR, nC, nLambda);
dsModel.PhiInc = zeros(nR, nLambda);

nAmp = length(dsModel.SrcAmp);
nSDPlane = nSDPair / nAmp;


%%
%%  Loop over wavelength
%%
for idxLambda = 1:nLambda
    %%
    %%  Generate a forward matrix for each frequency
    %%
    idxRow = 1;
    for idxFreq = 1:nFreq
        f = dsModel.ModFreq(idxFreq) * 1E6;
        if Debug
            fprintf('Modulation Freq: %e Hz\n', f);
        end

        switch dsModel.Boundary
        case 'Extrapolated'
            if Debug
                fprintf(['Executing extrapolated zero boundary' ...
                        ' computation\n']);
            end
            [A PhiInc] = dpdwfddazb(dsModel.CompVol, Mu_sp(idxLambda), ...
                dsModel.Mu_a(idxLambda), v(idxLambda), idxRefr(idxLambda), ...
                f, pSrc, pDet, Debug);
        case 'Infinite'
            if Debug
                fprintf(['Executing infinite medium boundary' ...
                        ' computation\n']);
            end
            [A PhiInc] = dpdwfdda(dsModel.CompVol, Mu_sp(idxLambda), ...
                dsModel.Mu_a(idxLambda), v(idxLambda), f, pSrc, pDet, ...
                Debug);
        otherwise
            error(['Unknown boundary condition: ' dsModel.Boundary]);
        end

        %%
        %%  Scale the amplitude of the forward matric and incident field if 
        %%  necessary.
        %%
        if nAmp > 1
            iStBlk = 1;
            for iAmp = 1:nAmp
                scale_factor = 10^(dsModel.SrcAmp(iAmp)/10);
                A(iStBlk:iStBlk+nSDPlane-1,:) = scale_factor * ...
                    A(iStBlk:iStBlk+nSDPlane-1,:);
                PhiInc(iStBlk:iStBlk+nSDPlane-1) = scale_factor * ...
                    PhiInc(iStBlk:iStBlk+nSDPlane-1);
                iStBlk  = iStBlk + nSDPlane;
            end
        end

        %%
        %%  Copy the forward matrix into the correct block
        %%
        dsModel.A(idxRow:idxRow+nSDPair-1,:,idxLambda) = real(A);
        dsModel.PhiInc(idxRow:idxRow+nSDPair-1,idxLambda) = real(PhiInc);
        idxRow = idxRow + nSDPair;            
        if f > 0
            dsModel.A(idxRow:idxRow+nSDPair-1,:,idxLambda) = imag(A);
            dsModel.PhiInc(idxRow:idxRow+nSDPair-1,idxLambda) = imag(PhiInc);
            idxRow = idxRow + nSDPair;
        end
    end
end
