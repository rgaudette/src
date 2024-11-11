%volumeRotate_DualTest  Examine volRotate and volRotateInv as dual operations
%
%   diffVol = volumeRotate_DualTest(volume, rotate, origin, method)
%
%   diffVolume  The difference volume between the input and output
%
%   rotate      The euler rotation to apply and then unapply
%
%   origin      OPTIONAL: The index location of the coordinate origin. The
%               volume is indexed in the following format.  The X-axis is
%               mapped to the row index, the Y-axis is mapped to the column
%               index and the Z-axis is mapped to the 3rd or plane index.
%               (default: [], the center of the volume)
%
%   method      OPTIONAL: The interpolation method (default: 'linear')
%               See interp3 for a list of interpolation methods.
%
%

%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/08/18 21:45:15 $
%
%  $Revision: 1.1 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function diffVol = volumeRotate_DualTest(volume, rotate, origin, method)

if nargin < 4
  method = [ ];
end

if nargin < 3 
  origin = [ ];
end
rVol = volumeRotate(volume, rotate, origin, method);
irVol = volumeRotateInv(rVol, -1 * rotate, origin, method);
diffVol = volume - irVol;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: volumeRotate_DualTest.m,v $
%  Revision 1.1  2005/08/18 21:45:15  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
