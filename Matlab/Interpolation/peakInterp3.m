%peakInterp3    Interpolate the peak value of a volume
%
%  [peakValue location] = peakInterp3(locX, locY, locZ, volume, locPeak,
%    rInterp, precision)
%
%   peakValue   The interpolated peak value.
%
%   location    The interpolated peak value location.
%
%   locX        The coordinates of the X,Y and Z pixel location.  Each vector
%   locY        should be the same length as the size of the dimension it is
%   locZ        associated with.
%
%   volume      The volume to be searched.
%
%   locPeak     The coordinate location of the current peak value
%
%   rInterp     The radius of the interpolation to calculate in the units of
%               locX, locY and locZ.
%
%   precision   The sampling step size to interpolate to.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/23 15:51:18 $
%
%  $Revision: 1.3 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [peakValue location] = peakInterp3(locX, locY, locZ, volume, ...
  locPeak, rInterp, precision)

if nargin < 7
  precision = 0.02;
end

% Compute the interpolation locations
iX = [locPeak(1)-rInterp:precision:locPeak(1)+rInterp]';
iY = locPeak(2)-rInterp:precision:locPeak(2)+rInterp;
iZ = locPeak(3)-rInterp:precision:locPeak(3)+rInterp;
[interpX interpY interpZ] = ndgrid(iX, iY, iZ);

% Interpolate the volume only at those locations
volInterp = interpn(locX, locY, locZ, volume, ...
  interpX, interpY, interpZ, 'spline');

% Find the peak in the interpolated volume
[peakValue indices] = arraymax(volInterp);
location = [iX(indices(1)) iY(indices(2)) iZ(indices(3))];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: peakInterp3.m,v $
%  Revision 1.3  2005/05/23 15:51:18  rickg
%  Comment updates
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
