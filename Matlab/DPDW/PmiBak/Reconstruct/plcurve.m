%PLCURVE        Plot the L-curve for a given set of reconstructions
%
%   [reg_c manualc] = plcurve(xest, A, b, lambda, flgManual, idxLabel)
%
%   xest        The set of estimates to be plotted
%
%   A           The forward model of the system.
%
%   b           The measured data.
%
%   lambda      OPTIONAL: The values of the regularization/truncation parameter.
%
%   idxLabel    The indices of the estimates to label.
%
%   Calls: none
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:37 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: plcurve.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:37  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [reg_c, manualc] = plcurve(xest, A, b, lambda, flgManual, idxLabel)

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
xnorm = zeros(nEst, 1);
for i = 1:nEst
    xnorm(i) = norm(xest(:,i));
end

%%
%%  Use PC Hansen's l_corner routine to find the corner
%%
%[reg_c rho_c eta_c] = l_corner(resid, xnorm, lambda);
reg_c = 0;

%%
%%  Plot the L-curve
%%
plot(log(resid), log(xnorm));
hold on
plot(log(resid), log(xnorm), 'x');
%plot(log(rho_c), log(eta_c), 'ro');

hax = gca;

ylabel('log(||x_{est}||)')
xlabel('log(||Ax_{est}-b||)')

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
    [v manualc] = min(abs(log(resid) - x));
end
