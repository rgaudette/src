%PLOT_LCURVE    Plot the L-Curve along with markers indicating the selected point
%
%   plot_lcurve(resid, xnorm, idxCorner)
%
%   resid
%
%   xnorm
%
%   idxCorner   OPTIONAL:

function plot_lcurve_vg(resid, xnorm, idxCorner, r_trunc)
clf
szLine = 3;
set(gcf, 'DefaultTextFontSize', 20);
set(gcf, 'DefaultTextFontWeight', 'normal');
set(gcf, 'DefaultAxesFontSize', 20);
set(gcf, 'DefaultAxesFontWeight', 'normal');
set(gcf, 'DefaultLineMarkerSize', 12);
set(gcf, 'DefaultLineLineWidth', szLine);

plot(log(resid), log(xnorm), 'r');
hold on
if nargin > 2
    plot(log(resid(idxCorner)), log(xnorm(idxCorner)), 'rd');
end
if nargin > 3
    Step = length(r_trunc) / 5;
    for i = 1:Step:length(r_trunc)
        plot(log(resid(i)), log(xnorm(i)), 'ro');
        text(log(resid(i)), log(xnorm(i)), ['  r=' int2str(r_trunc(i))]);
    end
end

grid

ylabel('log(||x_{est}||)')
xlabel('log(||Ax_{est}-b||)')
orient landscape