%GENFWDMAT      Generate the forward matrix from a Slab Image data structure.
%
%   ds = genfwdmat(ds);
%
%   ds          The slab image data structure to updated.
%
%
%   GENFWDDAT generates the forward matrix and incident field from the
%   parameters present in the slab image data structure.  The results are
%   placed in the data structure as the fields A and Phi_Inc respectively.
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
%  $Log: genfwdmat.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:14  rickg
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

function ds = genfwdmat(ds)

%%
%%  Source modulation frequency and source & detector positions
%%
[Xp Yp Zp] = meshgrid(ds.SrcPos.X, ds.SrcPos.Y, ds.SrcPos.Z-(1/ds.Mu_sp));
nSrc = prod(size(Xp));
pSrc = [Xp(:) Yp(:) Zp(:)];

[Xp Yp Zp] = meshgrid(ds.DetPos.X, ds.DetPos.Y, ds.DetPos.Z);
nDet = prod(size(Xp));
pDet = [Xp(:) Yp(:) Zp(:)];

%%
%%  Get the number of wavelength to compute
%%
nLambda = length(ds.Mu_a);
nNu = length(ds.nu);
if (nNu ~= 1) & (nNu ~= nLambda)
    error('Incorrect number of elements for nu field, fix index of refraction');
end
if nNu == 1
    nu = repmat(ds.nu, 1, nLambda);
else
    nu = ds.nu;
end

nMu_sp = length(ds.Mu_sp);
if (nMu_sp ~= 1) & (nMu_sp ~= nLambda)
    error('Incorrect number of elements for Mu_sp field, fix Mu_s or g');
end
if nMu_sp == 1
    Mu_sp = repmat(ds.Mu_sp, 1, nLambda);
else
    Mu_sp = ds.Mu_sp;
end

%%
%%  Preallocate the memory for the forward matrices and incident field
%%
nX = length(ds.CompVol.X);
nY = length(ds.CompVol.Y);
nZ = length(ds.CompVol.Z);
nSDPair = nDet * nSrc;
nFreq = length(ds.ModFreq);
nCmplx = sum(ds.ModFreq > 0);
nR = nSDPair * (nFreq + nCmplx);
nC = nX * nY *nZ;
ds.A = zeros(nR, nC, nLambda);
ds.Phi_Inc = zeros(nR, nLambda);

nAmp = length(ds.SrcAmp);
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
        f = ds.ModFreq(idxFreq) * 1E6;
        fprintf('Modulation Freq: %e Hz\n', f);

        switch ds.Boundary
        case 'Extrapolated'
            fprintf('Executing extrapolated zero boundary computation\n');
            [A Phi_Inc] = dpdwfddazb(ds.CompVol, Mu_sp(idxLambda), ...
                ds.Mu_a(idxLambda), nu(idxLambda), f, pSrc, pDet);
        
        case 'Infinite'
            fprintf('Executing infinite medium boundary computation\n');
            [A Phi_Inc] = dpdwfdda(ds.CompVol, Mu_sp(idxLambda), ...
                ds.Mu_a(idxLambda), nu(idxLambda), f, pSrc, pDet);
    
        otherwise
            error('Unknown boundary condition');
        end

        %%
        %%  Scale the amplitude of the forward matric and incident field if 
        %%  necessary.
        %%
        if nAmp > 1
            iStBlk = 1;
            for iAmp = 1:nAmp
                scale_factor = 10^(ds.SrcAmp(iAmp)/10);
                A(iStBlk:iStBlk+nSDPlane-1,:) = scale_factor * ...
                    A(iStBlk:iStBlk+nSDPlane-1,:);
                Phi_Inc(iStBlk:iStBlk+nSDPlane-1) = scale_factor * ...
                    Phi_Inc(iStBlk:iStBlk+nSDPlane-1);
                iStBlk  = iStBlk + nSDPlane;
            end
        end

        %%
        %%  Copy the forward matrix into the correct block
        nr = size(A,1);
        if f > 0
            ds.A(idxRow:idxRow+nr-1,:,idxLambda) = real(A);
            ds.Phi_Inc(idxRow:idxRow+nr-1,idxLambda) = real(Phi_Inc);
            idxRow = idxRow + nr;
            ds.A(idxRow:idxRow+nr-1,:,idxLambda) = imag(A);
            ds.Phi_Inc(idxRow:idxRow+nr-1,idxLambda) = imag(Phi_Inc);
            idxRow = idxRow + nr;
        else
            ds.A(idxRow:idxRow+nr-1,:,idxLambda) = A;
            ds.Phi_Inc(idxRow:idxRow+nr-1,idxLambda) = Phi_Inc;
            idxRow = idxRow + nr;            
        end
    end
end

%%
%%  Reset SVD flags.
%%
ds.flgNeedFullSVD = 1;
ds.flgNeedEconSVD = 1;
