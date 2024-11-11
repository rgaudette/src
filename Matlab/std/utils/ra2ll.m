%RA2LL          Convert range-azimuth from RSTER to lattitude and longitude.
%
%    [Lat Lon] = ra2ll(Range, Azimuth)
%
%    Range      The range from RSTER [NMi].
%
%    Azimuth    The angle from north [degrees].
%
%
%    Calls: phys_con, az22pol, pol2cart, cart2ll.
%
%    Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:24 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: ra2ll.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:24  rickg
%  Matlab Source
%
%  
%     Rev 1.0   11 Apr 1994 10:37:44   rjg
%  Initial revision.
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Lat, Lon] = ra2ll(Range, Azimuth)

%%
%%    Load in the physical constant definition file.
%%
phys_con;

%%
%%    Convert range to meters
%%
Range = Range / m2nmi;

%%
%%    Convert Range Azimuth to cartesian coordinates
%%
Z  = pol2cart(Range, az2pol(Azimuth));

%%
%%    Convert to lattitude and longitude
%%
[Lat Lon] = cart2ll(Z);
