%imodPoints2Index Convert imod points to MATLAB array indices
%
%   indices = ptsImod2Index(points)
%
%   indices     The MATLAB indices
%
%   points      The IMOD points
%
%   imodPoints2Index maps imod points to MATLAB array indices.  The center of
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
function indices = imodPoints2Index(points)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: imodPoints2Index.m,v 1.3 2005/08/15 23:17:36 rickg Exp $\n');
end

indices = points + repmat([0.5 0.5 1]', 1, size(points, 2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: imodPoints2Index.m,v $
%  Revision 1.3  2005/08/15 23:17:36  rickg
%  Type fix
%
%  Revision 1.2  2005/08/15 22:55:50  rickg
%  Added global print ID
%
%  Revision 1.1  2004/11/08 05:31:18  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
