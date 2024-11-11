%volSin        A limited support sin function in 3D
%
%   vol = volSin(argX, argY, argZ, length, width, frequency, phase, direction)
%
%   argX        3D arrays specifying the value of the X,Y, and Z
%   argY        coordinates.
%   argZ  
%
%   length      The length of support of the function.
%
%   width       The width of supportof the function.
%
%   frequency   OPTIONAL: The discrete frequency of the sin function
%               (default: 0.1)
%
%   phase       OPTIONAL: The phase shift of the sin function (default: 0)
%
%   direction   OPTIONAL: The ramp direction (default: 'X')
%
%
%   volSin generates a limited support sin function in 3D.
%
%   Calls: none
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/11/23 00:44:58 $
%
%  $Revision: 1.2 $
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function f = ...
  volSin(argX, argY, argZ, length, width, frequency, phase, direction)


if nargin < 6 || isempty(frequency)
  frequency = 0.1;
end

if nargin < 7 || isempty(phase)
  phase = 0;
end

if nargin < 8
  direction = 'X';
end

switch upper(direction)
  case 'X'
    argSin = argX;
    arg1 = argY;
    arg2 = argZ;
  case 'Y'
    argSin = argY;
    arg1 = argX;
    arg2 = argZ;
  case 'Z'
    argSin = argZ;
    arg1 = argX;
    arg2 = argY;
end

sinVar = sin(2 * pi * frequency *argZ) .* (abs(argSin) < length/2);

weight1 = supportWeight(arg1, width);
weight2 = supportWeight(arg2, width);

f =  sinVar .* weight1 .* weight2;