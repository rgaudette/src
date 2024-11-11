%XCORCOEF       Cross correlation coefficient.
%
%    Coeff = xcorcoef(x, y, range)
%
%    Coeff      Cross correlation coefficient.
%
%    x, y       Sequences to be compare, they must be the same length.
%
%    range      OPTIONAL: The indcies to cross correlate (default: all).
%
%        XCORCOEF computes the cross correlation coefficeint given by
%    formula,
%
%           _____ ,     _   _,
%           (X Y)   -  (X - Y )
%         ----------------------
%            std(X) * std(Y)
%
%    Calls: none.
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:21 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: xcorcoef.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:21  rickg
%  Matlab Source
%
%  
%     Rev 1.1   22 Mar 1994 09:24:32   rjg
%  Updated help description.
%   
%  
%     Rev 1.0   04 Jan 1994 16:10:18   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Coeff = xcorcoef(x, y, range)

%%
%%    Use all elements if no range is present
%%
if nargin < 3,
    Coeff = (mean(x .* conj(y)) - mean(x) .* mean(conj(y))) / ...
        (std(x) * std(y));

else
    Coeff = (mean(x(range) .* conj(y(range))) - ...
        mean(x(range)) .* mean(conj(y(range)))) / ...
        (std(x(range)) * std(y(range)));
end
