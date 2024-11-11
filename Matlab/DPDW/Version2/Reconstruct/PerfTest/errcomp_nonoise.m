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
%  $Date: 2004/01/03 08:26:11 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: errcomp_nonoise.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:11  rickg
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
%%   ART performance
%% 
disp('ART analysis')
[atr_te art_mae art_pae art_resid] = art_perf(A, b, x, 2*nr);

%%
%%   SIRT performance
%%
disp('SIRT analysis')
[sirt_te sirt_mae sirt_pae sirt_resid] = sirt_perf(A, b, x, 2*nr);


%%
%%  TSVD performance
%%
disp('TSVD analysis')    
[tsvd_te tsvd_mae tsvd_pae tsvd_resid] = tsvd_perf(A, b, x);

%%
%%  TCG performance
%%
disp('TCG analysis')    
[tcg_te tcg_mae tcg_pae tcg_resid] = tcg_perf(A, b, x, 2*nr);

%%
%%  MTSVD performance
%%
disp('MTSVD analysis')
vSV = [60:10:nr-1];
vLambda = logspace(-4,0,10);
[U S V] = svd(A);
[mtsvd_te mtsvd_mae mtsvd_pae mtsvd_resid] = mtsvd_perf(A, b, reshape(x,13,13,11), vSV, vLambda, U, S, V);
