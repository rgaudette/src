%gaussianMask   Compute a Gaussian mask
%
%   mask = gaussianMask(szArray, radius, sigma, center, flgHighPass)
%
%   mask        The calculated mask.
%
%   szArray     The size array to be masked, 1, 2 and 3 dimensional arrays
%               are currently implemented.
%
%   radius      The radius of the unit sphere to be used.  If this value is >= 1
%               then it is units of array indices, if is < 1 then it is relative
%               to szArray(1).
%
%   sigma       The decay parameter of the exponential function. If this value
%               is >= 1 then it is units of array indices, if is < 1 then it is
%               relative to szArray(1).
%
%   center      OPTIONAL: The center of the mask or [] for the center of the
%               supplied volume (default: floor(szArray / 2) + 1, to match
%               fftshift)
%
%   flgHighPass OPTIONAL: Specify a high pass mask that will be 1 at radii
%               greater than radius and decay towards zero as:
%               exp(-((radius-r)/sigma)^2)
%
%
%   gaussianMask computes a Gaussian mask function applicable to arrays of
%   size szArray.  The mask is one out to the radius and then decays
%   exponential as the function:
%
%     exp(-((r-radius)/sigma)^2)
%
%   If flgHighPass is true the behavior is reversed and the mask is one
%   from array extremeties to radius and decays as:
%
%     exp(-((radius-r)/sigma)^2)
%
%   towards the specified center of the array.
%
%   Calls: none
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/08/15 23:17:36 $
%
%  $Revision: 1.4 $
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mask = gaussianMask(szArray, radius, sigma, center, flgHighPass)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: gaussianMask.m,v 1.4 2005/08/15 23:17:36 rickg Exp $\n');
end

error(nargchk(1, 5, nargin))
if nargin < 5
  flgHighPass = 0;
end

if (nargin < 4) | isempty(center)
  center = floor(szArray / 2) + 1;
end

if radius < 1
  radius = radius * szArray(1);
end

if sigma < 1
  sigma = sigma * szArray(1);
end

% Compute the radial distance at each point in the array.

switch length(szArray)
  case 1
    r = abs([1:szArray(1)] - center(1));

  case 2
    [xsq ysq] = ndgrid(([1:szArray(1)] - center(1)) .^ 2, ...
      ([1:szArray(2)] - center(2)) .^ 2);
    r = sqrt(xsq + ysq);

  case 3
    [xsq ysq zsq] = ndgrid(([1:szArray(1)] - center(1)) .^ 2, ...
      ([1:szArray(2)] - center(2)) .^ 2, ...
      ([1:szArray(3)] - center(3)) .^ 2);
    r = sqrt(xsq + ysq + zsq);
  
  otherwise
    error('%d dimensional arrays not yet implemented', length(szArray))
end
if length(szArray) == 1
  mask = ones(szArray, 1);
else
  mask = ones(szArray);
end

% Calculate where to compute the gaussian transition region and the
% distance argument
if flgHighPass
  idxTaper = (r <= radius);
  rDiff = radius - r(idxTaper);
else
  idxTaper = (r >= radius);
  rDiff = r(idxTaper) - radius;
end

% Compute the expoential function over the transition region
mask(idxTaper) = exp(-(rDiff / sigma).^2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: gaussianMask.m,v $
%  Revision 1.4  2005/08/15 23:17:36  rickg
%  Type fix
%
%  Revision 1.3  2005/08/15 22:55:50  rickg
%  Added global print ID
%
%  Revision 1.2  2005/03/29 23:40:02  rickg
%  Can specify radius and std as a ratio of the volume size
%
%  Revision 1.1  2004/10/26 16:45:59  rickg
%  Inital revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
