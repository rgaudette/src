%CART2LL        Convert complex cartesian coordinates (relative to RSTER)
%               to latitude & longitude.
%
%    [Lat Lon] = cart2ll(Z)
%
%    Z          A vector conaining complex cartesian coordinates to be
%               converted.  The real part represents meters east of RSTER,
%               the imaginary part represents meters north of RSTER.
%
%    Lat        A vector containing the lattitudes to be converted [degrees].
%
%    Lon        A vector containing the longitudes tp be converted [degrees].
%
%
%        CART2LL converts a complex matrix representing dx and dy w.r.t
%    RSTER into a pair of latitude and longitude matricies.  The returned
%    latitude and longitude are measured in decimal degrees north and east.
%    
%        33.75158 N    -106.37202 E
%
%    RSTER position information is from GPS measurements on 14-Mar-94 by
%    Peter Geib.
%
%    Calls: none.
%
%    Bugs: not accurate in longitude large distances north and south of
%          of RSTER.  This is becuase it assumes a constant ratio of degrees
%          to meters east and west.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:24 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: cart2ll.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:24  rickg
%  Matlab Source
%
%  
%     Rev 1.1   22 Mar 1994 10:02:56   rjg
%  Upadted help description.
%  
%     Rev 1.0   17 Mar 1994 17:19:40   rjg
%  Initial revision.
%  
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Lat, Lon] = cart2ll(Z);

%%
%%    Constants radii taken from CRC 28th edition.
%%
EquatRadius = 6378388;
PolarRadius = 6356912;
RSTERLat = 33.75158;
RSTERLon = -106.37202;

%%
%%    Computer meters / degrees local to RSTER
%%
dy_dlat = 2 * pi * PolarRadius / 360;
dx_dlon = 2 * pi * EquatRadius * cos(RSTERLat * pi / 180) / 360;

Lat = RSTERLat + imag(Z) ./ dy_dlat;
Lon = RSTERLon + real(Z) ./ dx_dlon;
