%MPATH_DR	Compute the range differential between a direct path signal
%               and the specular multi-path.
%
%    dRange = mpath_dr(h1, h2, range)
%
%    dRange     Differential range between direct path signal and the 
%               specular multipath signal.
%
%    h1         Height of the source.
%
%    h2         Height of the receiver.
%
%    range      Range from source to receiver 
%
%	    Describe function, it's methods and results.
%
%    Calls: 
%
%    Bugs:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:09 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: mpath_dr.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:09  rickg
%  Matlab Source
%
%  
%     Rev 1.0   05 Jan 1994 14:06:50   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function dRange = mpath_dr(h1, h2, range)

dRange = sqrt(h1 .^ 2 + (h1 .* range / (h1 + h2)) .^2) + ...
         sqrt(h2 .^ 2 + (h2 .* range / (h1 + h2)) .^2) - ...
         sqrt(range .^ 2 + (h2 - h1) .^ 2);