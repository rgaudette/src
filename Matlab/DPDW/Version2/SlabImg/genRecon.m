%GENRECON       Generate the selected reconstruction.
%
%   ds = genrecon(ds)
%
%   ds          SlabImage data structure with result included.
%
%
%   Calls: art, sirt, fatmn, fattsvd, fatmtsvd, tcgls
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
%  $Log: genrecon.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:14  rickg
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

function ds = genrecon(ds)

%%
%%  Reconstruct image of volume
%%
nVoxels = size(ds.A, 2);
nLambda = size(ds.Phi_ScatN, 2);


%%
%%  Compute x estimate using requested algorithm
%%
ds.xhat = zeros(nVoxels, nLambda);
switch ds.ReconAlg

case 'Back Projection'
    for j = 1:nLambda
        %%
        %%  Rescale the backprojection matrix such that the norm of the rows
        %%  of the transpose of A are equal to 1.
        %%
        BPO = zeros(nVoxels, size(ds.A, 1));
        for i = 1:nVoxels
            temp = ds.A(:,i,j)';
            BPO(i,:) = temp ./ norm(temp);
        end
        ds.xhat(:,j) = BPO * ds.Phi_ScatN(:,j);
    end

case 'ART'
    for j = 1:nLambda
        ds.xhat(:,j) = art(ds.A_w(:,:,j), ds.Phi_ScatN_w(:,j), ...
            zeros(nVoxels, 1), ds.ARTnIter);
    end

case 'SIRT'
    for j = 1:nLambda
        ds.xhat(:,j) = sirt(ds.A_w(:,:,j), ds.Phi_ScatN_w(:,j), ...
            zeros(nVoxels, 1), ds.SIRTnIter);
    end
    
case 'Min. Norm'
    for j = 1:nLambda
        ds.xhat(:,j) = fatmn(ds.A_w(:,:,j), ds.Phi_ScatN_w(:,j));
    end
    
case 'TSVD'
    for j = 1:nLambda
        if ds.flgNeedEconSVD
            [ds.xhat(:,j) ds.Uecon(:,:,j) ds.Secon(:,:,j) ds.Vecon(:,:,j)] = ...
                fattsvd(ds.A_w(:,:,j), ds.Phi_ScatN_w(:,j), ds.TSVDnSV);
            if j == nLambda
                ds.flgNeedEconSVD = 0;
            end
        else
            disp('Already have econ SVD');
            ds.xhat(:,j) = fattsvd(ds.A_w(:,:,j), ds.Phi_ScatN_w(:,j), ...
                ds.TSVDnSV, ds.Uecon(:,:,j), ds.Secon(:,:,j), ds.Vecon(:,:,j));
        end
    end

    
case 'MTSVD'
    LaplOp = lapl3d(length(ds.CompVol.X),length(ds.CompVol.Y),...
        length(ds.CompVol.Z));
    for j = 1:nLambda
        if ds.flgNeedFullSVD
            %%
            %%  If the system has changed we must recompute the full SVD as
            %%  well as the MTSVD solution
            %%
            fprintf('Computing full MTSVD\n')
            ds.xtsvd = zeros(nVoxels, nLambda);
            ds.xns = zeros(nVoxels, nLambda);
            [ds.xhat(:,j) ds.xtsvd(:,j) ds.xns(:,j) ...
                    ds.U(:,:,j) ds.S(:,:,j) ds.V(:,:,j)] = ...
                fatmtsvd(ds.A_w(:,:,j), ds.Phi_ScatN_w(:,j), ds.MTSVDnSV, ...
                LaplOp, ds.MTSVDLambda);
            prev_nSV = ds.MTSVDnSV;
            if j == nLambda
                ds.flgNeedFullSVD = 0;
            end

        elseif ds.MTSVDnSV == prev_nSV
            %%
            %%  If all that has been modified is lambda we can quickly compute
            %%  the result.
            %%
            fprintf('Only changed lambda\n')
            ds.xhat(:,j) = ds.xtsvd(:,j) - ds.MTSVDLambda * ds.xns(:,j);
    
        else    
            %%
            %%  If the system is still the same then recompute using the
            %%  existing SVD computation
            %% 
            fprintf('Recomputing optimum NULL space contribution\n')
            [ds.xhat(:,j) ds.xtsvd(:,j) ds.xns(:,j)] = ...
                fatmtsvd(ds.A_w(:,:,j), ds.Phi_ScatN_w(:,j), ds.MTSVDnSV, ...
                LaplOp, ds.MTSVDLambda, U(:,:,j), S(:,:,j), V(:,:,j));
            prev_nSV = ds.MTSVDnSV;
        end
    
    end

case 'TCG'
    %%
    %%  Truncated normal equation solution
    %%
    for j = 1:nLambda
        ds.xhat(:,j) = tcgls(ds.A_w(:,:,j), ds.Phi_ScatN_w(:,j), ds.TCGnIter);
    end
    
otherwise
    error(['Unknown reconstruction technique: ' ds.ReconAlg]);
end

%%
%%  Print out performance measures of the reconstruction
%%
for j = 1:nLambda
    ds.xerror(:,j) = ds.xhat(:,j) - ds.del_mu_a(:,j);
    fprintf('Lambda #%d\n', j);
    fprintf('  Normalized 2-norm of the error: %f\n', ...
        norm(ds.xerror(:,j))/norm(ds.del_mu_a(:,j)));
    fprintf('  Mean abs value of the error: %f\n', mean(abs(ds.xerror(:,j))));
    fprintf('  Maximum difference %f\n', max(ds.xerror(:,j)));
    fprintf('  Minimum difference %f\n', min(ds.xerror(:,j)));

    ds.xresid(:,j) = ds.A(:,:,j) * ds.xhat(:,j) - ds.Phi_ScatN(:,j);
    fprintf('  2-norm of residual: %f\n', norm(ds.xresid(:,j)));
    ds.xresid = ds.A(:,:,j) * ds.xhat(:,j) - ds.Phi_Scat(:,j);
    fprintf('  2-norm of residual w.r.t. exact measurements: %f\n\n', ...
        norm(ds.xresid));
end
