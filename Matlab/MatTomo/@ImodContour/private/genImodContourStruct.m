%genImodContourStruct  Generate a default ImodContour structure
%
%   imodContour = genImodContourStruct
%
%   imodContour The ImodContour object structure.
%
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 15:56:49 $
%
%  $Revision: 1.5 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function imodContour = genImodContourStruct

imodContour.nPoints = 0;
imodContour.flags = 0;
imodContour.type = 0;
imodContour.iSurface = 0;
imodContour.points = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: genImodContourStruct.m,v $
%  Revision 1.5  2005/05/09 15:56:49  rickg
%  Comment updates
%
%  Revision 1.4  2005/05/09 15:56:10  rickg
%  Comment updates
%
%  Revision 1.3  2004/09/18 20:41:22  rickg
%  Updated default values
%
%  Revision 1.2  2003/02/22 00:14:46  rickg
%  Fixed imodContour references
%
%  Revision 1.1  2003/01/11 18:30:40  rickg
%  *** empty log message ***
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
