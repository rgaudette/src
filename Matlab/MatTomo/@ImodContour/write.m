%write         Write the ImodContour
%
%   write(imodContour, fid)
%
%   imodContour The ImodContour object.
%
%   fid         A file ID of an open file with the pointer at the start of an
%               IMOD contour object.
%
%   Write out the ImodContour to the specified fid.
%   
%   Calls: none
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 15:56:10 $
%
%  $Revision: 1.2 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function writeHeader(imodContour, fid)

writeAndCheck(fid, 'CONT', 'uchar');
writeAndCheck(fid, imodContour.nPoints, 'int32');
writeAndCheck(fid, imodContour.flags, 'int32');
writeAndCheck(fid, imodContour.type, 'int32');
writeAndCheck(fid, imodContour.iSurface, 'int32');
writeAndCheck(fid, imodContour.points, 'float32');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: write.m,v $
%  Revision 1.2  2005/05/09 15:56:10  rickg
%  Comment updates
%
%  Revision 1.1  2004/09/17 23:56:10  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
