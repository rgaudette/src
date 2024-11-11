%RECVELM2       RECVELM1 with residual gradient removal.
%
%   [vel grad df_dt] = rvelmall(Data, szArray, Scales, idxStart,
%                                           pctThrsh, SaStep, rngGradResid)
%
%   vel         Velocity estimate.  This is a complex number with the real
%               part representing horizontal (along rows) velocity and the
%               imaginary part representing vertical (up columns) velocity.
%
%   grad        The spatial gradient estimate at the given scale.
%
%   Data        Lead data.
%
%   szArray     Array size [nRows nCols]
%
%   Scales      Mallat detail scales to use [time x y].
%
%   idxStart    Search start index.
%
%   pctThrsh    Threshold percentage.
%
%   SaStep      Sampling step sizes [dt dx dy].
%
%   rngGradResid   The range measure the residual gradient present in the ST
%               segment.  If this is 0 or not present the gradient at
%               idxStart is used.  If a range is given a mean gradient for
%               each lead is evaluated over the range.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:41 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: recvelm2.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:41  rickg
%  Matlab Source
%
%  Revision 1.1  1997/07/18 18:31:26  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [vel, grad, tdb, detT, detG, Tth, Gth] = ...
    recvelm2(Data, szArray, Scales, idxStart, pctThrsh, SaStep, rngGradResid)

%%
%%  Default parameters and parameter checking
%%
if nargin < 7
    rngGradResid = 0;
    if nargin < 6
        SaStep = [1 1 1];
        if nargin < 5,
            pctThrsh = 25;
            if nargin < 4,
                idxStart = 1;
                if nargin < 3,
                    Scales = [2 2 2];
                    if nargin < 2,
                        if nargin < 1,
                            help recvelm2
                            return;
                        end
                        error('Lead array size must be specified');
                    end
                end
            end
        end
    end
end


%%
%%   Compute the derivatives of the signal
%%
disp('Computing wavelet decomposition...');
[tdb rdb cdb] = mall3d(Data, szArray, Scales(1), Scales(2), Scales(3));

%%
%%  Compute the gradient using the combined row & column derivatives.
%%
disp('Computing gradient...')
grad = wavegrad(rdb, cdb, SaStep(2), SaStep(3));

%%
%%  REMOVE THE RESIDUAL GRADIENT
%%
[nR nC] = size(grad);
if rngGradResid == 0
    meanGrad = grad(:, idxStart);
else
    meanGrad = mean(grad(:, rngGradResid).').';
end
grad = grad - repmat(meanGrad, 1, nC);

%%
%%  Select appropriate derivative estimates
%%
disp('Computing velocity...');
tdb = tdb ./ SaStep(1);
[vel detT detG]= recvel(tdb, grad, idxStart, pctThrsh);
