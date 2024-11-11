%PLCURVE        Plot the L-curve for a given set of reconstructions
%
%   plcurve(resid, xnorm, flgMark, residMark, normMark)
%
%   resid       The residual vector
%
%   xnorm       The norm vector
%
%   flgMark     OPTIONAL: Mark the values plotted with a x along with the line.
%
%   residMark   OPTIONAL: The value of the residual at the selected point, this
%               point will be marked with an o.
%
%   normMark    OPTIONAL: The value of the norm at the selected point, this
%               point will be marked with an o.
%
%
%   Calls: none
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
%  $Log: plcurve.m,v $
%  Revision 1.1.1.1  2004/01/03 08:27:30  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plcurve(resid, xnorm, flgMark, residMark, normMark)

if nargin < 3
    flgMark = 0;
end
flgPointMark = 0;

if nargin >= 5
    flgPointMark = 1;
end
%%
%%  Plot the log of the norm vs. the log of the residual
%%
plot(log(resid), log(xnorm));
hold on
if flgMark
    plot(log(resid), log(xnorm), 'x');
end
if flgPointMark
    plot(log(residMark), log(normMark), 'ro');
end
hold off

ylabel('log(||x_{est}||)')
xlabel('log(||Ax_{est}-b||)')

