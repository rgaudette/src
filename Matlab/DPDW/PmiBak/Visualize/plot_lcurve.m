%PLOT_LCURVE    Plot the L-Curve along with markers indicating the selected point
%
%   plot_lcurve(resid, xnorm, idxCorner)
%
%   resid
%
%   xnorm
%
%   idxCorner   OPTIONAL:
function plot_lcurve(resid, xnorm, idxCorner)

plot(log(resid), log(xnorm), 'k');
hold on
plot(log(resid), log(xnorm), 'kx');
if nargin > 2
    plot(log(resid(idxCorner)), log(xnorm(idxCorner)), 'kd');
end

nPts = length(resid) / 10;

grid on

ylabel('log_e(||x_{est}||)')
xlabel('log_e(||Ax_{est}-b||)')
orient landscape