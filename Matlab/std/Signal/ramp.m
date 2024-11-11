%RAMP           Ramp signal clipped at 1 and -1, centered on 0.
%
%   s = ramp(x, slope)
%
%   s           ramp signal
%
%   x           function argument
%
%   slope       slope term

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:20 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: ramp.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:20  rickg
%  Matlab Source
%
%  Revision 1.1  1997/07/31 19:05:50  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function s = ramp(x, slope)

%%
%%  Compute the s = 1 intersect index 
%%
intersect = 1/slope;
s = zeros(size(x));
idxOne = abs(x) > intersect;
s(idxOne) = sign(x(idxOne));
s(~idxOne) = x(~idxOne) .* slope;

