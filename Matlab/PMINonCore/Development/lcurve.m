%LCURVE         Compute and plot the L-curve for a given set of reconstructions
%
%   [regc manualc resid xnorm] = lcurve(xest, A, b, lambda, flgManual, idxLabel)
%
%   regc        The automicaly selected regularization parameter.
%
%   manc        The manually selected regularization parameter.
%
%   resid       The residual as a function of lambda.
%
%   norm        The norm as a function of lambda.
%
%   xest        The set of estimates to be plotted
%
%   A           The forward model of the system.
%
%   b           The measured data.
%
%   lambda      OPTIONAL: The values of the regularization/truncation parameter.
%
%   flgManual   OPTIONAL: Set to true for manual selection of the corner.
%
%   idxLabel    OPTIONAL: The indices of the estimates to label.
%
%   Calls: residual, vecnorm, l_corner, plcurve
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:27:30 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: lcurve.m,v $
%  Revision 1.1.1.1  2004/01/03 08:27:30  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [regc, manc, resid, xnorm] = lcurve(xest, A, b, lambda, flgManual, ...
    idxLabel)

if nargin < 5
    flgManual = 0;
end

nEst = size(xest, 2);
if nargin < 4
    lambda = zeros(nEst,1);
end

%%
%%  Calculate the residual and norm of the estimates
%%
resid = residual(b, A, xest);
xnorm = vecnorm(xest);

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
    [v manc] = min(abs(log(resid) - x));
end
