%genImodObject       Generate a default ImodObject structure
%
%   imodObject = genImodObjectStruct
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 15:46:55 $
%
%  $Revision: 1.7 $
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function imodObject = genImodObjectStruct

imodObject.name  = '';

imodObject.nContours = 0;
imodObject.flags = 0;
imodObject.axis = 0;
imodObject.drawMode = 1;
imodObject.red = 0.0;
imodObject.green = 0.0;
imodObject.blue = 0.0;
imodObject.pdrawsize = 0.0;
imodObject.symbol = 1;
imodObject.symbolSize = 3;
imodObject.lineWidth2D = 1;
imodObject.lineWidth3D = 1;
imodObject.lineStyle = 0;
imodObject.symbolFlags = 0;
imodObject.sympad = 0;
imodObject.transparency = 0;
imodObject.nMeshes = 0;
imodObject.nSurfaces = 0;

imodObject.contour = {};
imodObject.mesh = {};
imodObject.surface = {};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: genImodObjectStruct.m,v $
%  Revision 1.7  2005/05/09 15:46:55  rickg
%  *** empty log message ***
%
%  Revision 1.6  2004/09/18 20:41:22  rickg
%  Updated default values
%
%  Revision 1.5  2004/09/18 00:01:05  rickg
%  Changed red default value
%
%  Revision 1.4  2003/03/04 05:38:15  rickg
%  Variable name change for objects
%
%  Revision 1.3  2003/02/14 23:31:16  rickg
%  fixed initial surfaces assignment
%
%  Revision 1.2  2003/01/31 05:47:29  rickg
%  Added missing objects
%
%  Revision 1.1  2003/01/11 18:36:09  rickg
%  *** empty log message ***
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

