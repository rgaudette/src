%RCOSPULSE      Raised cosine pulse.
%
%   s = rcospulse(x, period)
%
%   s           Raised cosine pulse signal
%
%   x           Function argument
%
%   period      The period of the pulse.
%
%   RCOSPULSE generates a raised cosine pulse one period long centered around
%   the zero value(s) of x.  The pulse support is from -period/2 to
%   period/2. The amplitude of the pulse is from 0 to 1.
%
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:20 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: rcospulse.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:20  rickg
%  Matlab Source
%
%  Revision 1.1  1997/07/31 18:58:00  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function s = rcospulse(x, period)

s = zeros(size(x));

%%
%%  Find where the pulse support is for each vector in x.
%%
idxSupport = find((x >= -period/2) & (x <= period/2));
s(idxSupport) = (cos(x(idxSupport) ./ period .* (2 * pi)) + 1) ./ 2;
