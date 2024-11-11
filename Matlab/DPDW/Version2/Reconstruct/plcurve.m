%PLCURVE        Plot the L-curve for a given set of reconstructions
%
%   [reg_c manualc] = plcurve(xest, A, b, lambda, flgManual)
%
%   xest        The set of estimates to be plotted
%
%   A           The forward model of the system.
%
%   b           The measured data.
%
%   lambda      OPTIONAL: The values of the regularization/truncation parameter.
%
%   Calls: nu2deriv
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:08 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: plcurve.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:08  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [reg_c, manualc] = plcurve(xest, A, b, lambda, flgManual)

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
[reg_c rho_c eta_c] = l_corner(resid, xnorm, lambda);

%%
%%  Plot the L-curve
%%
plot(log(resid), log(xnorm));
hold on
plot(log(resid), log(xnorm), 'x');
plot(log(rho_c), log(eta_c), 'ro');

hax = gca;

ylabel('log(||x_{est}||)')
xlabel('log(||Ax_{est}-b||)')

if flgManual
    [x y] = ginput(1);
    [v manualc] = min(abs(log(resid) - x));
end
