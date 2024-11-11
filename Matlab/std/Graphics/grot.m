%GROT           Rotate a graph in the current figure
%
%   grot(degrees, axis)
%
%   degrees     The number of degrees to rotate.
%
%   axis        OPTIONAL: a string specifying the axis to rotate
%               either 'az' or 'el' (default: 'az')
%
%	GROT uses the view commmand to reset the observation point of the
%   the current figure.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:05 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: grot.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:05  rickg
%  Matlab Source
%
%  Revision 1.1  1998/04/15 22:52:30  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function grot(Degrees, Axis)

if nargin < 2,
   Axis = 'az';
end

[Azimuth Elevation] = view;

if length(Axis) > 1,
    tokAxis = lower(Axis(1:2));
    if tokAxis == 'az',
        view([Azimuth+Degrees Elevation]);
    elseif tokAxis == 'el',
        view([Azimuth Elevation+Degrees]);
    else
        error(['Unknown axis string: ' Axis]);
    end
else
    error(['Unknown axis string: ' Axis]);
end
