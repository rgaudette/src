%RLCURVE        Plot the L-curve given a set of residuals and norms.
%
%   [regc manualc] = rlcurve(resid, xnorm, lambda, flgManual, idxLabel)
%
%   regc        The automicaly selected regularization parameter.
%
%   manc        The manually selected regularization parameter.
%
%   resid       The residual as a function of lambda.
%
%   xnorm       The norm as a function of lambda.
%
%   lambda      OPTIONAL: The values of the regularization/truncation parameter.
%
%   flgManual   OPTIONAL: Set to true for manual selection of the corner.
%
%   idxLabel    OPTIONAL: The indices of the estimates to label.
%
%   Calls: l_corner, plcurve
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:27:29 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: rlcurve.m,v $
%  Revision 1.1.1.1  2004/01/03 08:27:29  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [regc, manc] = rlcurve(resid, xnorm, lambda, flgManual, idxLabel)

if nargin < 4
    flgManual = 0;
end
flgManual
nEst = length(resid);
if nargin < 4
    lambda = 1;nEst;
end

%%
%%  Use PC Hansen's l_corner routine to find the corner
%%
regc = 0;
[regc rho_c eta_c] = myl_corner(resid', xnorm', lambda');


%%
%%  Plot the L-curve
%%
clf
plcurve(resid, xnorm, 1, rho_c, eta_c)

if nargin > 5
    for iLabel = idxLabel
        text(log(resid(iLabel)), log(xnorm(iLabel)), int2str(lambda(iLabel)));
    end
end

if flgManual
    zoom on
    str = input('zoom is on, press s to select a point: ', 's');
    while ~strcmp('s', str)
        str = input('zoom is on, press s to select a point: ', 's');
    end
    zoom off
    
    [x y] = ginput(1);
    [v idx] = min(abs(log(resid) - x));
    manc = lambda(idx);
end

