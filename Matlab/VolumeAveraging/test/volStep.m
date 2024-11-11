%volStep        A limited support step function in 3D
%
%   vol = volStep(argX, argY, argZ, length, width, direction)
%
%   argX        3D arrays specifying the value of the X,Y, and Z
%   argY        coordinates.
%   argZ  
%
%   length      The length of support of the function.
%
%   width       The width of support of the function.
%
%   direction   OPTIONAL: The step direction (default: 'X')
%
%
%   volStep generates a limited support step function in 3D.
%
%   Calls: none
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/11/30 01:53:35 $
%
%  $Revision: 1.3 $
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function f = volStep(argX, argY, argZ, length, width, direction)

if nargin < 6
  direction = 'X';
end

[argStep arg1 arg2] = domainMap(argX, argY, argZ, direction);
weight1 = supportWeight(arg1, width);
weight2 = supportWeight(arg2, width);

stepVar = sign(argStep) .* (abs(argStep) < length/2);

f = stepVar .* weight1 .* weight2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: volStep.m,v $
%  Revision 1.3  2004/11/30 01:53:35  rickg
%  *** empty log message ***
%
%  Revision 1.2  2004/11/20 17:40:27  rickg
%  *** empty log message ***
%
%  Revision 1.1  2004/11/19 00:49:31  rickg
%  *** empty log message ***
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
