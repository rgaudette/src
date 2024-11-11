%volRamp        A limited support ramp function in 3D
%
%   vol = volRamp(argX, argY, argZ, length, width, slope, direction)
%
%   argX        3D arrays specifying the value of the X,Y, and Z
%   argY        coordinates.
%   argZ  
%
%   length      The length of support of the function.
%
%   width       The width of supportof the function.
%
%   slope       OPTIONAL: The slope of the ramp (default: 2 / length)
%
%   direction   OPTIONAL: The ramp direction (default: 'X')
%
%
%   volramp generates a limited support ramp function in 3D.
%
%   Calls: none
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/11/23 00:45:20 $
%
%  $Revision: 1.3 $
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function f = volRamp(argX, argY, argZ, length, width, slope, direction)

if nargin < 6 || isempty(slope)
  slope = 2 / length;
end

if nargin < 7
  direction = 'X';
end

switch upper(direction)
  case 'X'
    argRamp = argX;
    arg1 = argY;
    arg2 = argZ;
  case 'Y'
    argRamp = argY;
    arg1 = argX;
    arg2 = argZ;
  case 'Z'
    argRamp = argZ;
    arg1 = argX;
    arg2 = argY;
end

rampVar = (2 * argRamp / length) .* (abs(argRamp) < length/2);
weight1 = supportWeight(arg1, width);
weight2 = supportWeight(arg2, width);

f = rampVar .* weight1 .* weight2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: volRamp.m,v $
%  Revision 1.3  2004/11/23 00:45:20  rickg
%  Check to see if slope is empty
%
%  Revision 1.2  2004/11/20 17:40:27  rickg
%  *** empty log message ***
%
%  Revision 1.1  2004/11/19 00:49:31  rickg
%  *** empty log message ***
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
