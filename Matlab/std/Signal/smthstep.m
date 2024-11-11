%SMTHSTEP       Smoothed step signal
%
%   s = smthstep(x, alpha)
%
%   s           smoothed step signal
%
%   x           function argument
%
%   alpha       slope term
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
%  $Log: smthstep.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:20  rickg
%  Matlab Source
%
%  Revision 1.1  1997/07/31 19:12:39  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function s = smthstep(x, alpha)

s = sign(x) .* (-1 * exp(-1*alpha*abs(x)) + 1);
