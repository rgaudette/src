%LL2CART        Convert lattitude and longitude to cartesian coordinates
%               relative to RSTER.
%
%    [xDist yDist] = ll2cart(Lat, Lon)
%
%    xDist      Meters east of RSTER.
%
%    yDist      Meters north of RSTER.
%
%    Lat        A vector containing the lattitudes to be converted
%               [degrees north].
%                   
%
%    Lon        A vector containing the longitudes tp be converted
%               [degrees east].
%
%        LL2CART converts a pair of lattitude / longitude matrices into
%    a pair of vectors representing the distance from RSTER in meters with
%    respsect to east and north.  This function assumes RSTER position is,
%
%        33.75158 N    -106.37202 E
%
%    RSTER position information is from GPS measurements on 14-Mar-94 by
%    Peter Geib.
%
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
%  $Log: ll2cart.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:24  rickg
%  Matlab Source
%
%  
%     Rev 1.2   22 Mar 1994 10:10:50   rjg
%  Updated help description.
%   
%  
%     Rev 1.1   17 Mar 1994 17:19:48   rjg
%  Adjusted RSTER position from Pete's information.
%  
%     Rev 1.0   27 Sep 1993 17:08:54   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [xDist, yDist] = ll2cart(Lat, Lon)

%%
%%    Constants
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

%%
%%    Compute dx, dy for lat and long given
%%
xDist =  (Lon - RSTERLon) * dx_dlon;
yDist = (Lat - RSTERLat) * dy_dlat;
