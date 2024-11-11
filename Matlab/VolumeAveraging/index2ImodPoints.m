%imodPoints2Index Convert imod points to MATLAB array indices
%
%   points = index2ImodPoints(indices)
%
%   points      The IMOD points
%
%   indices     The MATLAB indices
%
%   imodPoints2Index maps MATLAB array indices to imod points.  The center of
%   an IMOD voxel is on 1/2 index values for X and Y and unit index values for Z
%   Calls: none
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/08/15 23:17:36 $
%
%  $Revision: 1.3 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function points = index2ImodPoints(indices)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: index2ImodPoints.m,v 1.3 2005/08/15 23:17:36 rickg Exp $\n');
end

points = indices - repmat([0.5 0.5 1]', 1, size(indices, 2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: index2ImodPoints.m,v $
%  Revision 1.3  2005/08/15 23:17:36  rickg
%  Type fix
%
%  Revision 1.2  2005/08/15 22:55:50  rickg
%  Added global print ID
%
%  Revision 1.1  2004/11/30 01:54:23  rickg
%  *** empty log message ***
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
