%ACTVEL         Compute the activation wavefront velocity
%
%   [velocity detT detG] = actvel(dv_dt, grad, idxStart, thresh_pct)
%
%   velocity    The computed velocity of the activation wavefront.
%
%   detT        The detected regions of temporal derivative.
%
%   detG        The detected regions of the gradient.
%
%   dv_dt       The temporal derivative for each spatial point and time.
%
%   grad        The spatial gradient for each spatial point and time.
%
%   idxStart    The temporal index at which to start detecting the derivatives.
%
%   thresh_pct  The threshold value as a percentage of peak value for each
%               derivative.  A threshold is computed individually for each
%               spatial location.
%
%   ACTVEL computes the velocity of the wavefront around the activation
%   event.  The activation event is identified by finding indices with
%   temporal derivatives AND spatial gradients larger (in magnitude) than
%   a threshold.  The thresholds are a percentage (thresh_pct) of the
%   maximum value of the temporal derivative and spatial gradient for each
%   lead.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:40 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: actvel.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:40  rickg
%  Matlab Source
%
%  Revision 1.2  1997/03/26 22:36:37  rjg
%  Change thresh_pct to actually be a percentage
%
%  Revision 1.1  1997/03/26 18:59:29  rjg
%  Initial revision
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [velocity, detT, detG, TempThresh, GradThresh] = ...
    actvel(dv_dt, grad, idxStart, thresh_pct)

%%
%%  Compute the recovery velocity by find thresholding the spatial
%%  and temporal derivatives with respsect to maximum found in
%%  recovery region
%%

[nLeads nSamples] = size(dv_dt);
detG = zeros(nLeads, nSamples);
detT = zeros(nLeads, nSamples);
velocity = zeros(nLeads, nSamples);

GradThresh = max(abs(grad(:, idxStart:nSamples)).').' * (thresh_pct / 100);
TempThresh = min(dv_dt(:, idxStart:nSamples).').' * (thresh_pct / 100);

%%
%%  Search temporally through each lead from idxStart on to find samples
%%  that are greater than the threshold.
%%
for iLead = 1:nLeads,
    detG(iLead, idxStart:nSamples) = ...
        abs(grad(iLead, idxStart:nSamples)) > GradThresh(iLead);
    detT(iLead, idxStart:nSamples) = dv_dt(iLead, idxStart:nSamples) < ...
                                     TempThresh(iLead);
end
idxBoth = find(detT & detG);

velocity(idxBoth) = -1 * dv_dt(idxBoth) ./ grad(idxBoth);