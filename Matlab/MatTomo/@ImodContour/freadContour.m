%freadContour   ImodContour file reader
%
%   imodContour = freadContour(imodContour, fid)
%
%   imodContour The ImodContour object.
%
%   fid         A file ID of an open file with the pointer at the start of an
%               IMOD contour object.
%
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 16:19:21 $
%
%  $Revision: 1.6 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function imodContour = freadContour(imodContour, fid, debug)

%  Check to make sure we have a Imod Contour
ID = char(fread(fid, [1 4], 'uchar'));

if strncmp('CONT', ID, 4) ~= 1
  error('This is not a IMOD Contour object');
end

imodContour.nPoints = fread(fid, 1, 'int32');
imodContour.flags = fread(fid, 1, 'int32');
imodContour.type = fread(fid, 1, 'int32');
imodContour.iSurface = fread(fid, 1, 'int32');
imodContour.points = reshape(fread(fid, imodContour.nPoints * 3, ...
                                'float32'),  3, imodContour.nPoints);

if debug
  fprintf('    points: %d\n', imodContour.nPoints);
  fprintf('    flags:  %d\n', imodContour.flags);
  fprintf('    type:  %d\n', imodContour.type);
  fprintf('    surf:  %d\n', imodContour.iSurface);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: freadContour.m,v $
%  Revision 1.6  2005/05/09 16:19:21  rickg
%  Comment updates
%
%  Revision 1.5  2005/05/09 15:56:10  rickg
%  Comment updates
%
%  Revision 1.4  2004/10/01 23:36:03  rickg
%  Fixed string TAG reading
%
%  Revision 1.3  2004/09/18 20:42:50  rickg
%  Added debug section
%
%  Revision 1.2  2003/02/22 00:15:31  rickg
%  Fixed strncmp call and nPoints reference
%
%  Revision 1.1  2003/02/22 00:02:31  rickg
%  moved freadContour to public
%
%  Revision 1.2  2003/01/31 05:45:21  rickg
%  Corrected object name
%
%  Revision 1.1  2003/01/11 18:30:40  rickg
%  *** empty log message ***
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
