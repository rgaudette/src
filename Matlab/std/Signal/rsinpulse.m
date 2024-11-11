%RSINPULSE      Raised sine pulse.
%
%   s = rsinpulse(x, period)
%
%   s           Raised sine pulse signal
%
%   x           Function argument
%
%   period      The period of the pulse.
%
%   RSINPULSE generates a raised sine pulse one period with the maximum
%   derivative occuring at zero value(s) of x.  The pulse support is from 
%   -period/4 to 3*period/4. The amplitude of the pulse is from 0 to 1.
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
%  $Log: rsinpulse.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:20  rickg
%  Matlab Source
%
%  Revision 1.2  1997/07/31 19:01:21  rjg
%  Corrected help header.
%
%  Revision 1.1  1997/07/31 18:57:18  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function s = rsinpulse(x, period)

s = zeros(size(x));

%%
%%  Find where the pulse support is for each vector in x.
%%
idxSupport = find((x >= -period/4) & (x <= 3*period/4));
s(idxSupport) = (sin(x(idxSupport) ./ period .* (2 * pi)) + 1) ./ 2;
