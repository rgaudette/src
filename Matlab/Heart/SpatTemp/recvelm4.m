%RECVELM4       RECVELM3 with residual gradient removal.
%
%   [vel grad df_dt] = recvelm4(Data, szArray, Scales, idxStart,
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
%  $Log: recvelm4.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:41  rickg
%  Matlab Source
%
%  Revision 1.1  1997/07/18 18:33:24  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [vel, grad, tdb, detT, detG, Tth, Gth] = ...
    recvelm4(Data, szArray, Scales, idxStart, pctThrsh, SaStep, rngGradResid)

%%
%%  Default parameters and parameter checking
%%
if nargin < 7,
    rngGradResid = 0;
    if nargin < 6,
        SaStep = [1 1 1];
        if nargin < 5,
            pctThrsh = 25;
            if nargin < 4,
                idxStart = 1;
                if nargin < 3,
                    Scales = [2 2 2];
                    if nargin < 2,
                        if nargin < 1,
                            help recvelm4.m
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
disp('Computing forward diff wavelets...');
[tdb rdf cdf] = mall3df(Data, szArray, Scales(1), Scales(2), Scales(3));
disp('Computing backward diff wavelets...');
[tdb rdb cdb] = mall3d(Data, szArray, Scales(1), Scales(2), Scales(3));

%%
%%  Split the backward temporal derivative into positive and negative
%%  values
%%
disp('Selecting appropriate differnces...');
pos_td = tdb >= 0;
neg_td = ~pos_td;

%%
%%  Find the indices of the row derivatives the have the same sign as the
%%  backward temporal derivatives.  Use these values as the row derivtive
%%  estimate, otherwise use the forward derivative estimate.  Apply the 
%%  same process to column derivatives
%%
same_r = (pos_td & (rdb >= 0)) | (neg_td & (rdb < 0));
rd_est = zeros(size(rdb));
rd_est(same_r) = rdb(same_r) ./ SaStep(2);
rd_est(~same_r) = rdf(~same_r) ./ SaStep(2);
clear rdb rdf same_r

same_c = (pos_td & (cdb >= 0)) | (neg_td & (cdb < 0));
cd_est = zeros(size(cdb));
cd_est(same_c) = cdb(same_c) ./ SaStep(3);
cd_est(~same_c) = cdf(~same_c) ./ SaStep(3);
clear same_c pos_td neg_td cdb cdf

%%
%%  Compute the gradient using the combined row & column derivatives.
%%
disp('Computing gradient...')
grad = wavegrad(rd_est, cd_est, SaStep(2), SaStep(3));
clear rd_est cd_est

%%
%%  Remove the residual gradient
%%
[nr nC] = size(grad);
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
%fwdsel_r = (~same_r) * (-1) + same_r;
%fwdsel_c = (~same_c) * (-1) + same_c;
