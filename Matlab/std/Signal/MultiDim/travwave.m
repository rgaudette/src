%TRAVWAVE       Traveling wave function of 1 spatial dimension and time.
%
%   f = travwave(t, x, vel, fctWave, arg1, arg2)
%
%   f           The function matrix evaluated at x and t.  x varies with
%               row index and t varies with column index.
%
%   t           The time values at which to evaluate the function.
%
%   x           The space values at which to evaluate the function.
%
%   vel         The velocity of the wave in units of x and t.
%
%   fctWave     The waveform to use.  This must be an M-file that evaluates
%               a matrix to one value for each value given.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:21 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: travwave.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:21  rickg
%  Matlab Source
%
%  Revision 1.1  1997/01/22 19:06:19  rjg
%  Initial revision
%
%
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function f = travwave(t, x, vel, fctWave, arg1, arg2)

%%
%%  make sure t is a row vector and x is a column vector.
%%
x = x(:);
t = t(:)';

fctArg = ones(length(x),1) * t - x * ones(1, length(t));

%%
%%  Evaluate the function with the requested arguments
%%
if nargin < 5,
    f = feval(fctWave, fctArg);
elseif nargin == 5,
    f = feval(fctWave, fctArg, arg1);
else
    f = feval(fctWave, fctArg, arg1, arg2);
end
