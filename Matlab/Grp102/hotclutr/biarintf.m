%BIARINTF		Bistatic area integration function.
%
%    f = biarintf(e, theta)
%
%    f		Integrand result.
%
%    e		Eccentricity matrix.
%
%    theta	Angle matrix.
%
%	    BIARINTF computes the integration function (closed) for
%    BISTAT_RES.  e and theta must be the same size, the result f will also
%    be this size.
%
%    Calls: 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:29 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: biarintf.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:29  rickg
%  Matlab Source
%
%  
%     Rev 1.0   26 Mar 1993 11:01:00   rjg
%  Initial revision.
%  
%     Rev 1.0   19 Mar 1993 15:04:22   rjg
%  Initial revision.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function f = biarintf(e, theta)

%%
%%    Pre-compute tan(theta / 2) matrix
%%
tan_theta_2 = tan(theta / 2);

f = (1 - e .^ 2) .^ (-3/2) .* ...
    (atan(sqrt((1 + e) ./ (1 - e)) .* tan_theta_2) + ...
    (e .* sqrt(1 - e .^ 2) .* tan_theta_2) ./ ...
    ((1 - e) + (1+e) .* tan_theta_2 .^ 2));
