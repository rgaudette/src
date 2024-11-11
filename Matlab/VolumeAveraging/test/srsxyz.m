%srsxyz         Step-ramp-sin particle in X, Y & Z repsectively
%
%   vol = srsxyz(argX, argY, argZ, length, width, slope, frequency, phase)
%
%   argX        3D arrays specifying the value of the X,Y, and Z
%   argY        coordinates.
%   argZ  
%
%   length      The length of support of the function.
%
%   width       The width of support of the function.
%
%   slope       OPTIONAL: The slope of the ramp (default: 2 / length)
%
%   frequency   OPTIONAL: The discrete frequency of the sin function
%               (default: 0.1)
%
%   phase       OPTIONAL: The phase shift of the sin function (default: 0)
%
%
%   srsxyz generates a step-ramp-sin particle in the in the X, Y & Z
%   directions repsectively.
%
%   Calls: volStep, volRamp, volSin
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/11/30 01:54:23 $
%
%  $Revision: 1.1 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function vol = srsxyz(argX, argY, argZ, length, width, slope, frequency, phase)

  vol = volStep(argX, argY, argZ, length, width);
  vol = vol + volRamp(argX, argY, argZ, length, width, slope, 'Y');
  vol = vol + volSin(argX, argY, argZ, length, width, frequency, phase, 'Z');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: srsxyz.m,v $
%  Revision 1.1  2004/11/30 01:54:23  rickg
%  *** empty log message ***
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
