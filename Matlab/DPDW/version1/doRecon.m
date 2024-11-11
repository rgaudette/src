%doRecon        Calculate the measured data from the slab image parms.
%
%   This script extracts the current system parameters from the GUI Slab
%   image interface and reconstructs a set of images based from the measured
%   data and the forward matrix.
%
%   Calls: art, sirt, fatmn, fattsvd, fatmtsvd
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
% Date: 1998/04/29 15:13:24 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: doRecon.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:57  rickg
%  Matlab Source
%
%  Revision 1.6  1998/08/05 15:34:49  rjg
%  Uses string descriptions of reconstruction algorithms instead of SIdefines
%  codes.
%
%  Revision 1.5  1998/06/11 17:56:04  rjg
%  Fixed bug where the null space contribution in the MTSVD was recomputed
%  when only lambda had changed but the null space size had changed in a
%  previous iteration.  Basically forgot to reset the prev null space size.
%
%  Revision 1.4  1998/06/10 18:26:05  rjg
%  Changed bn to Phi_ScatN for compatibility with doMeasData.
%  Fixed bug regarding reseting flag for economy SVD.
%
%  Revision 1.3  1998/06/03 16:33:37  rjg
%  Uses SIdefines codes
%  Added MTSVD operations
%
%  Revision 1.2  1998/04/29 15:13:24  rjg
%  Added busy light
%
%  Revision 1.1  1998/04/28 20:20:04  rjg
%  Initial revision
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
UIHandles = get(gcf, 'UserData');
set(UIHandles.hLight, 'Color', [1 0 0]);
drawnow;

ds = getall;
%%
%%  Reconstruct image of volume
%%
Xv = R(1):dr(1):R(2);
nX = length(Xv);
Yv = R(3):dr(2):R(4);
nY = length(Yv);
Zv = R(5):dr(3):R(6);
nZ = length(Zv);
nVoxel = nX * nY * nZ;

switch ds.ReconAlg
case 'Back Projection'
    xhat = A' * Phi_ScatN;

case 'ART'
    xhat = art(A, Phi_ScatN, zeros(nVoxel, 1), ds.ARTnIter);

case 'SIRT'
    %%
    %%  Use backprojection and guess of inhomogeneity magnitude to ...
    %%  initialize SIRT starting point.
    %%
    %xfirst = A' * Phi_ScatN;
    %xmax = max(xfirst);
    %xfirst = xfirst ./ xmax * 0.1;
    xhat = sirt(A, Phi_ScatN, zeros(nVoxel, 1), ds.SIRTnIter);

case 'Min. Norm'
    xhat = fatmn(A, Phi_ScatN);

case 'TSVD'
    if flgNeedEconSVD
        [xhat Uecon Secon Vecon] = fattsvd(A, Phi_ScatN, ds.TSVDnSV);
        flgNeedEconSVD = 0;
    else
        [xhat] = fattsvd(A, Phi_ScatN, ds.TSVDnSV, Uecon, Secon, Vecon);
    end

case 'MTSVD'
    LaplOp = lapl3d(nX, nY, nZ);

    if flgNeedFullSVD
        %%
        %%  If the system has changed we must recompute the full SVD as
        %%  well as the MTSVD solution
        %%
        fprintf('Computing full MTSVD\n')
        [xhat xtsvd xns U S V] = ...
            fatmtsvd(A, Phi_ScatN, ds.MTSVDnSV, LaplOp, ds.MTSVDLambda);
        prev_nSV = ds.MTSVDnSV;
        flgNeedFullSVD = 0;

    elseif ds.MTSVDnSV == prev_nSV
        %%
        %%  If all that has been modified is lambda we can quickly compute the
        %%  result.
        %%
        fprintf('Only changed lambda\n')
        xhat = xtsvd - ds.MTSVDLambda * xns;
    
    else    
        %%
        %%  If the system is still the same then recompute using the existing
        %%  SVD computation
        %% 
        fprintf('Recomputing optimum NULL space contribution\n')
        [xhat xtsvd xns] = ...
            fatmtsvd(A, Phi_ScatN, ds.MTSVDnSV, LaplOp, ds.MTSVDLambda, U, S, V);
            prev_nSV = ds.MTSVDnSV;
    end
end

set(UIHandles.hLight, 'Color', [0 1 0]);
drawnow;
