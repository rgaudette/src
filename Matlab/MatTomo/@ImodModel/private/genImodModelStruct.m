%genImodModelStruct     Generate a default ImodModel structure
%
%   imodModel = genImodModelStruct
%
%   imodModel   The ImodModel object.
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/08 17:33:03 $
%
%  $Revision: 1.5 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function imodModel = genImodModelStruct

imodModel.fid = [];
imodModel.filename = '';
imodModel.endianFormat = 'ieee-be';
imodModel.version = 'V1.2';

imodModel.name  = 'ImodModel';
imodModel.xMax = 0;
imodModel.yMax = 0;
imodModel.zMax = 0;
imodModel.nObjects = 0;
imodModel.flags = 0;
imodModel.drawMode = 1;
imodModel.mouseMode = 0;
imodModel.blackLevel = 0;
imodModel.whiteLevel = 255;
imodModel.xOffset = 0;
imodModel.yOffset = 0;
imodModel.zOffset = 0;
imodModel.xScale = 1.0;
imodModel.yScale = 1.0;
imodModel.zScale = 1.0;
imodModel.object = 0;
imodModel.contour = 0;
imodModel.point = 0;
imodModel.res = 0;
imodModel.thresh = 0;
imodModel.pixelSize = 0;
imodModel.units = 0;
imodModel.csum = 0;
imodModel.alpha = 0;
imodModel.beta = 0;
imodModel.gamma = 0;
imodModel.Objects = {};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: genImodModelStruct.m,v $
%  Revision 1.5  2005/05/08 17:33:03  rickg
%  Comment update
%
%  Revision 1.4  2004/09/18 20:43:51  rickg
%  Variable name change
%
%  Revision 1.3  2004/09/18 00:02:22  rickg
%  Changed default values to true numbers
%
%  Revision 1.2  2003/02/14 23:23:16  rickg
%  Added fid, filename endianFormat and version
%
%  Revision 1.1  2003/01/11 18:36:09  rickg
%  *** empty log message ***
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
