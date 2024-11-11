%ERRCOMP        Run a complete error analysis for a given system
%
%   Input variables:
%   A, x, vSNR
%   result      Output description.
%
%   parm        Input description [units: MKS].
%
%   Optional    OPTIONAL: This parameter is optional (default: value).
%
%
%   TEMPLATE Describe function, it's methods and results.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:39 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: errcomp.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:39  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%  compute the unperturbed data
%%
[nr nc] = size(A);
b = A * x;

%%
%%  Loop over the given noise values
%%
nSNR = length(vSNR);

for iSNR = 1:nSNR
    %%
    %%  Add noise to the measurement
    NoiseSTD = zeros(size(b));
    for iMeas = 1:length(b);
        NoiseSTD(iMeas)  = abs(b(iMeas)) * (10 ^ (-1 * vSNR(iSNR) / 20));
    end
    Noise = randn(size(b)) .* NoiseSTD;
    bn = b + Noise;

    %%
    %%  Weight the measurements according to the noise STD
    %%
    w = NoiseSTD .^ -1;
    A_w = diag(w) * A;
    bn_w = w .* bn;

    %%
    %%   ART performance
    %% 
    disp('ART analysis')
    [te mae pae resid] = art_perf(A_w, bn_w, x, 2*nr);
    eval(['art_te_' int2str(vSNR(iSNR)) 'dB = te;']);
    eval(['art_mae_' int2str(vSNR(iSNR)) 'dB = mae;']);
    eval(['art_pae_' int2str(vSNR(iSNR)) 'dB = pae;']);
    eval(['art_resid_' int2str(vSNR(iSNR)) 'dB = resid;']);
    
    %%
    %%   SIRT performance
    %%
    disp('SIRT analysis')
    [te mae pae resid] = sirt_perf(A_w, bn_w, x, 2*nr);
    eval(['sirt_te_' int2str(vSNR(iSNR)) 'dB = te;']);
    eval(['sirt_mae_' int2str(vSNR(iSNR)) 'dB = mae;']);
    eval(['sirt_pae_' int2str(vSNR(iSNR)) 'dB = pae;']);
    eval(['sirt_resid_' int2str(vSNR(iSNR)) 'dB = resid;']);

        
    %%
    %%  TSVD performance
    %%
    disp('TSVD analysis')    
    [te mae pae resid] = tsvd_perf(A_w, bn_w, x);
    eval(['tsvd_te_' int2str(vSNR(iSNR)) 'dB = te;']);
    eval(['tsvd_mae_' int2str(vSNR(iSNR)) 'dB = mae;']);
    eval(['tsvd_pae_' int2str(vSNR(iSNR)) 'dB = pae;']);
    eval(['tsvd_resid_' int2str(vSNR(iSNR)) 'dB = resid;']);
    
    %%
    %%  TCG performance
    %%
    disp('TCG analysis')    
    [te mae pae resid] = tcg_perf(A_w, bn_w, x, 2*nr);
    eval(['tcg_te_' int2str(vSNR(iSNR)) 'dB = te;']);
    eval(['tcg_mae_' int2str(vSNR(iSNR)) 'dB = mae;']);
    eval(['tcg_pae_' int2str(vSNR(iSNR)) 'dB = pae;']);
    eval(['tcg_resid_' int2str(vSNR(iSNR)) 'dB = resid;']);
    
    %%
    %%  MTSVD performance
    %%
    disp('MTSVD analysis')
    vSV = [60:10:nr-1];
    vLambda = logspace(-4,0,10);
    [U S V] = svd(A_w);
    [te mae pae resid] = mtsvd_perf(A_w, bn_w, reshape(x,13,13,11), vSV, vLambda, U, S, V);
    eval(['mtsvd_te_' int2str(vSNR(iSNR)) 'dB = te;']);
    eval(['mtsvd_mae_' int2str(vSNR(iSNR)) 'dB = mae;']);
    eval(['mtsvd_pae_' int2str(vSNR(iSNR)) 'dB = pae;']);
    eval(['mtsvd_resid_' int2str(vSNR(iSNR)) 'dB = resid;']);
    
end
