%AZ2POL         Converts north based azimuth angles to polar radians.
%
%    Radians = az2pol(Azimuth)
%
%    Radians    Output matrix of corresponding polar angles [radians].
%
%    Azimuth    Input matrix of azimuth angles [degrees].
%
%	    AZ2POL converts north based azimuth angles in units of degress
%    to polar angles in radians.   This function is useful if complex numbers
%    are being used to represent east-west (real) and north-south (imag).
%
%    Calls: none.
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:24 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: az2pol.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:24  rickg
%  Matlab Source
%
%  
%     Rev 1.0   30 Aug 1993 10:37:36   rjg
%  Initial revision.
%  
%     Rev 1.0   04 Aug 1993 22:59:42   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Polar = az2pol(Azimuth)

%%
%%    Rotate origin of azimuths to match polar.
%%
Azimuth = Azimuth - 90;

%%
%%    Change sign, polar angles rotate counter-clockwise.
%%
Azimuth = - Azimuth;

%%
%%    Find any values >180 or <-180, perform mod 360 arithmetic on them.
%%
idxLow = find(Azimuth < -180);
Azimuth(idxLow) = Azimuth(idxLow) + 360;

idxHigh = find(Azimuth > 180);
Azimuth(idxHigh) = Azimuth(idxHigh) - 360;

Polar = Azimuth * pi / 180;
