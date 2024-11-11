%wedgeMask      Limited angle tomography valid frequency domain binary mask
%
%   mask = wedgeMask(rngTiltAxis, szVol, repeatDomain, edgeShift)
%
%   mask        The binary mask of the valid frequency domain data.
%
%   rngTiltAxis The minimum and maximum angles of the tilt axis in degrees
%               as [minAx maxAx].  This should be specified in the same
%               orientation as the data from a rawtilt or align.log.
%
%   szVol       The size of the fourier volume
%
%   repeatDomain  OPTIONAL: The domain in which the mask is invariant
%               (default: 'Y').
%
%   edgeShift   OPTIONAL: The number of pixels to shift the mask boundary
%               to ensure that all good frequency information is included
%               (default: 0).
%
%   wedgeMask creates a 3D mask that indicates where valid information is
%   present in the frequency domain.  The mask create is appropriate for a
%   frequency domain represention that has had fftshift applied.
%
%   Calls: none
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/08/19 22:12:13 $
%
%  $Revision: 1.9 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mask = wedgeMask(rngTiltAxis, szVol, repeatDomain, edgeShift)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: wedgeMask.m,v 1.9 2005/08/19 22:12:13 rickg Exp $\n');
end

if nargin < 4
  edgeShift = 0;
end

% Convert the tilt range to radians and swap the sense of what is positve
% and negative
rngTiltAxis = rngTiltAxis([2 1]) * -pi / 180;

% Map the appropriate axis according the repeatDomain parameter
if nargin < 4
  repeatDomain = 'Y';
end
repeatDomain = upper(repeatDomain);
switch repeatDomain
  case 'Y'
    nI = szVol(1);
    nJ = szVol(3);
  case 'X'
    nI = szVol(2);
    nJ = szVol(3);
  case 'Z'
    nI = szVol(1);
    nJ = szVol(2);
end

freqI = ([0:nI-1] - floor(nI / 2)) / nI;
freqJ = ([0:nJ-1] - floor(nJ / 2)) / nJ;
[aFreqI aFreqJ] = ndgrid(freqI', freqJ);

% TODO: a more elegant approach would be to shift the edge in a direction
% normal to the tilt axis angle for each quadrant
warning('off', 'MATLAB:divideByZero')
shiftI = aFreqI + edgeShift / nI;
quad1Mask = ((aFreqJ ./ shiftI) <= tan(rngTiltAxis(2))) ...
  & (aFreqJ >= 0) & (shiftI >= 0);
quad4Mask = ((aFreqJ ./ shiftI) >= tan(rngTiltAxis(1))) ...
  & (aFreqJ <= 0) & (shiftI >= 0);

shiftI = aFreqI - edgeShift / nI;
quad2Mask = ((aFreqJ ./ shiftI) >= tan(rngTiltAxis(1))) ...
  & (aFreqJ >= 0) & (shiftI < 0);
quad3Mask = ((aFreqJ ./ shiftI) <= tan(rngTiltAxis(2))) ...
  & (aFreqJ <= 0) & (shiftI < 0);
warning('on', 'MATLAB:divideByZero') 
mask = quad1Mask | quad2Mask | quad3Mask | quad4Mask;
% Make sure the DC component is set to 1
mask(floor(nI/2)+1, floor(nJ/2)+1)=1;

switch repeatDomain
  case 'Y'
    mask = permute(mask, [1 3 2]);
    mask = repmat(mask, [1 szVol(2) 1]);
    
  case 'X'
    mask = permute(mask, [3 1 2]);
    mask = repmat(mask, [szVol(1) 1 1]);
    
  case 'Z'
    mask = repmat(mask, [1 1 szVol(3)]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: wedgeMask.m,v $
%  Revision 1.9  2005/08/19 22:12:13  rickg
%  Comment fix
%
%  Revision 1.8  2005/08/15 23:17:37  rickg
%  Type fix
%
%  Revision 1.7  2005/08/15 22:55:50  rickg
%  Added global print ID
%
%  Revision 1.6  2005/03/04 00:28:20  rickg
%  Changed the rotation sign sense to match the IMOD tilt sense
%
%  Revision 1.5  2005/02/18 23:50:25  rickg
%  edgeShift comment
%
%  Revision 1.4  2005/02/10 19:35:40  rickg
%  Added edgeShift functionality
%
%  Revision 1.3  2004/11/09 01:09:02  rickg
%  Help update
%
%  Revision 1.2  2004/11/02 00:36:01  rickg
%  Inital revision
%
%  Revision 1.1  2004/10/29 18:40:45  rickg
%  *** empty log message ***
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

