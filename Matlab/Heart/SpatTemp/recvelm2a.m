%RECVELM2A      RECVELM1 with residual gradient removal and unmodified detection
%
%   [vel grad df_dt] = recvelm2a(Data, szArray, Scales, idxStart,
%                                pctThrsh, SaStep, rngGradResid)
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
%   Scales      [OPTIONAL] Mallat detail scales to use [time x y]
%               (default: [2 2 2]).
%
%   idxStart    [OPTIONAL] Search start index (default: 1).
%
%   pctThrsh    [OPTIONAL] Threshold percentage (default: 25).
%
%   SaStep      [OPTIONAL] Sampling step sizes [dt dx dy] (default: [1 1 1]).
%
%   rngGradResid   [OPTIONAL] The range to measure the residual gradient present
%               in the ST segment.  If this is 0 or not present the gradient
%               at idxStart is used.  If a range is given a mean gradient for
%               each lead is evaluated over the range.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:41 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: recvelm2a.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:41  rickg
%  Matlab Source
%
%  Revision 1.1  1997/07/18 18:31:37  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [vel, grad, tdb, detT, detG, TempThresh, GradThresh] = ...
    recvelm2a(Data, szArray, Scales, idxStart, pctThrsh, SaStep, rngGradResid)

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
%%  Select appropriate derivative estimates
%%
disp('Computing velocity...');
tdb = tdb ./ SaStep(1);
[nLeads nSamples] = size(tdb);

%%
%%  Find a threshold level for each lead
%%
GradThresh = max(abs(grad(:, idxStart:nSamples)).').' * (pctThrsh / 100);
TempThresh = max(tdb(:, idxStart:nSamples).').' * (pctThrsh / 100);

%%
%%  Search temporally through each lead from idxStart on to find samples
%%  that are greater than the threshold.
%%
detG = zeros(nLeads, nSamples);
detT = zeros(nLeads, nSamples);
for iLead = 1:nLeads,
    detG(iLead, idxStart:nSamples) = ...
        abs(grad(iLead, idxStart:nSamples)) > GradThresh(iLead);
    detT(iLead, idxStart:nSamples) = tdb(iLead, idxStart:nSamples) > ...
                                     TempThresh(iLead);
end

%%
%%  Velocity is computed only where both the gradient and the derivative ...
%%  are above their respective thresholds
%%
idxBoth = find(detT & detG);

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
%%  Compute the velocity of the detected wavefront
%%
vel = zeros(nLeads, nSamples);
vel(idxBoth) = -1 * tdb(idxBoth) ./ grad(idxBoth);
