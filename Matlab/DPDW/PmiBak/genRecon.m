%GenRecon       Generate the selected Reconstruction.
%
%   ds = genRecon(ds)
%
%   ds          The DPDW Imaging data structure with result included.
%
%
%   Calls: art, sirt, fatmn, fattsvd, fatmtsvd, tcgls
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
%  $Log: genRecon.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:31  rickg
%  Matlab Source
%
%  Revision 2.1  1999/02/05 20:43:34  rjg
%  Added help brief comments.
%
%  Revision 2.0  1999/02/05 20:40:09  rjg
%  *** empty log message ***
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ds = genRecon(ds)

%%
%%  Calculate an esimate of the weighted scattered field
%%
WScatEst = ds.PhiTotalNw - ds.Noise.w .* ds.Inv.PhiInc;

%%
%%  Reconstruct image of volume
%%
nVoxels = size(ds.Inv.A, 2);
nLambda = size(WScatEst, 2);


%%
%%  Compute x estimate using requested algorithm
%%
ds.Recon.xEst = zeros(nVoxels, nLambda);
switch ds.Recon.ReconAlg

case 'Back Projection'
    for j = 1:nLambda
        %%
        %%  Rescale the backprojection matrix such test the norm of the rows
        %%  of the transpose of A are equal to 1.
        %%
        BPO = zeros(nVoxels, size(ds.Inv.A, 1));
        for i = 1:nVoxels
            temp = ds.Inv.A(:,i,j)';
            BPO(i,:) = temp ./ norm(temp);
        end
        ds.Recon.xEst(:,j) = BPO * WScatEst(:,j);
    end

case 'ART'
    for j = 1:nLambda
        ds.Recon.xEst(:,j) = art(ds.Inv.Aw(:,:,j), WScatEst(:,j), ...
            zeros(nVoxels, 1), ds.Recon.ARTnIter);
    end

case 'SIRT'
    for j = 1:nLambda
        ds.Recon.xEst(:,j) = sirt(ds.Inv.Aw(:,:,j), WScatEst(:,j), ...
            zeros(nVoxels, 1), ds.Recon.SIRTnIter);
    end
    
case 'Min. Norm'
    for j = 1:nLambda
        ds.Recon.xEst(:,j) = fatmn(ds.Inv.Aw(:,:,j), WScatEst(:,j));
    end
    
case 'TSVD'
    for j = 1:nLambda
        if ds.Recon.flgNeedEconSVD
            if ds.Debug
                disp('Computing economy SVD');
            end
            if j == 1
                ds.Recon.Secon = []
                ds.Recon.Vecon = [];
                ds.Recon.Uecon = [];
            end
            
            [ds.Recon.xEst(:,j) ds.Recon.Uecon(:,:,j) ...
                    ds.Recon.Secon(:,:,j) ds.Recon.Vecon(:,:,j)] = ...
                fattsvd(ds.Inv.Aw(:,:,j), WScatEst(:,j), ds.Recon.TSVDnSV);
            if j == nLambda
                ds.Recon.flgNeedEconSVD = 0;
            end
        else
            if ds.Debug
                disp('Already have economy SVD');
            end
            ds.Recon.xEst(:,j) = fattsvd(ds.Inv.Aw(:,:,j), WScatEst(:,j), ...
                ds.Recon.TSVDnSV, ds.Recon.Uecon(:,:,j), ...
                ds.Recon.Secon(:,:,j), ds.Recon.Vecon(:,:,j));
        end
    end
    
case 'MTSVD'
    LaplOp = lapl3d(length(ds.Inv.CompVol.X),length(ds.Inv.CompVol.Y),...
        length(ds.Inv.CompVol.Z));
    for j = 1:nLambda
        if ds.Recon.flgNeedFullSVD
            %%
            %%  If the system has changed we must recompute the full SVD as
            %%  well as the MTSVD solution
            %%
            if ds.Debug
                fprintf('Computing full MTSVD\n')
            end
            ds.Recon.xTSVD = zeros(nVoxels, nLambda);
            ds.Recon.xNS = zeros(nVoxels, nLambda);
            ds.Recon.S = [];
            ds.Recon.V = [];
            ds.Recon.U = [];
            [ds.Recon.xEst(:,j) ds.Recon.xTSVD(:,j) ds.Recon.xNS(:,j) ...
                    ds.U(:,:,j) ds.S(:,:,j) ds.V(:,:,j)] = ...
                fatmtsvd(ds.Inv.Aw(:,:,j), WScatEst(:,j), ...
                ds.Recon.MTSVDnSV, LaplOp, ds.Recon.MTSVDLambda);
            prev_nSV = ds.Recon.MTSVDnSV;
            if j == nLambda
                ds.Recon.flgNeedFullSVD = 0;
            end

        elseif ds.Recon.MTSVDnSV == prev_nSV
            %%
            %%  If all test has been modified is lambda we can quickly compute
            %%  the result.
            %%
            if ds.Debug
                fprintf('Only changed lambda\n')
            end
            ds.Recon.xEst(:,j) = ds.Recon.xTSVD(:,j) - ...
                ds.Recon.MTSVDLambda * ds.Recon.xNS(:,j);
            
    
        else    
            %%
            %%  If the system is still the same then recompute using the
            %%  existing SVD computation
            %% 
            if ds.Debug
                fprintf('Recomputing optimum NULL space contribution\n')
            end
            [ds.Recon.xEst(:,j) ds.Recon.xTSVD(:,j) ds.Recon.xNS(:,j)] = ...
                fatmtsvd(ds.Inv.Aw(:,:,j), WScatEst(:,j), ...
                ds.Recon.MTSVDnSV, LaplOp, ds.MTSVDLambda, ...
                ds.Recon.U(:,:,j), ds.Recon.S(:,:,j), ds.Recon.V(:,:,j));
            prev_nSV = ds.Recon.MTSVDnSV;
        end
    end

case 'TCG'
    %%
    %%  Truncated normal equation solution
    %%
    for j = 1:nLambda
        ds.Recon.xEst(:,j) = tcgls(ds.Inv.Aw(:,:,j), WScatEst(:,j), ...
            ds.Recon.TCGnIter);
    end
    
otherwise
    error(['Unknown Reconstruction technique: ' ds.Recon.ReconAlg]);
end

%%
%%  Generate Inverse problem true object for performance comparisons
%%
if isfield(ds, 'Object')
    nLambda = size(ds.Inv.Mu_a, 2);
    nVoxels = size(ds.Inv.A, 2);
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
    ds.Inv.delMu_a = zeros(nVoxels, nLambda);
    for iLambda = 1:nLambda
        for iSphere = 1:nSphere
            tmp = gensphere1(ds.Inv.CompVol, ds.Object.SphereCtr(iSphere,:), ...
                ds.Object.SphereRad(iSphere, :), ds.Object.SphereDelta(iSphere, ...
                iLambda));
            ds.Inv.delMu_a(:, iLambda) = ds.Inv.delMu_a(:, iLambda) + tmp(:);
        end
        for iBlock = 1:nBlock
            tmp = genblock(ds.Inv.CompVol, ds.Object.BlockCtr(iBlock,:), ...
                ds.Object.BlockDims(iBlock, :), ...
                ds.Object.BlockDelta(iBlock, iLambda));
            ds.Inv.delMu_a(:, iLambda) = ds.Inv.delMu_a(:, iLambda) + tmp(:);
        end
    end
end


%%
%%  Print out performance measures of the Reconstruction
%%
if ds.Debug > 0
    ds.Recon.xError = [];
    ds.Recon.xResid = [];
    for j = 1:nLambda
        ds.Recon.xError(:,j) = ds.Recon.xEst(:,j) - ds.Inv.delMu_a(:,j);
        fprintf('Lambda #%d\n', j);
        fprintf('  Normalized 2-norm of the error: %f\n', ...
            norm(ds.Recon.xError(:,j))/norm(ds.Inv.delMu_a(:,j)));
        fprintf('  Mean abs value of the error: %f\n', ...
            mean(abs(ds.Recon.xError(:,j))));
     
        
        fprintf('  Maximum difference %f\n', max(ds.Recon.xError(:,j)));
        fprintf('  Minimum difference %f\n', min(ds.Recon.xError(:,j)));

        ds.Recon.xResid(:,j) = ds.Inv.Aw(:,:,j) * ds.Recon.xEst(:,j) - ...
            WScatEst(:,j);
        fprintf('  2-norm of residual: %f\n', norm(ds.Recon.xResid(:,j)));
    end
end
