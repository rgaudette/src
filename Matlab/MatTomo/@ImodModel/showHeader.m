%showHeader     Display the model header
%
%   showHeader(imodModel)
%
%   imodModel   The ImodModel object.
%
%   ImodModel.showHeader will display the header of supplied ImodModel object.
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/08 17:22:49 $
%
%  $Revision: 1.4 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function showHeader(imodModel);

fprintf('Name: %s\n', imodModel.name);
fprintf('xMax %d\n', imodModel.xMax);
fprintf('yMax %d\n', imodModel.yMax);
fprintf('zMax %d\n', imodModel.zMax);
fprintf('nObjects %d\n', imodModel.nObjects);
fprintf('flags %d\n', imodModel.flags);
fprintf('drawMode %d\n', imodModel.drawMode);
fprintf('mouseMode %d\n', imodModel.mouseMode);
fprintf('blackLevel %d\n', imodModel.blackLevel);
fprintf('whiteLevel %d\n', imodModel.whiteLevel);
fprintf('xOffset %f\n', imodModel.xOffset);
fprintf('yOffset %f\n', imodModel.yOffset);
fprintf('zOffset %f\n', imodModel.zOffset);
fprintf('xScale %f\n', imodModel.xScale);
fprintf('yScale %f\n', imodModel.yScale);
fprintf('zScale %f\n', imodModel.zScale);
fprintf('object %d\n', imodModel.object);
fprintf('contour %d\n', imodModel.contour);
fprintf('point %d\n', imodModel.point);
fprintf('res %d\n', imodModel.res);
fprintf('thresh %d\n', imodModel.thresh);
fprintf('pixelSize %f\n', imodModel.pixelSize);
fprintf('units %d\n', imodModel.units);
fprintf('csum %d\n', imodModel.csum);
fprintf('alpha %d\n', imodModel.alpha);
fprintf('beta %d\n', imodModel.beta);
fprintf('gamma %d\n', imodModel.gamma);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: showHeader.m,v $
%  Revision 1.4  2005/05/08 17:22:49  rickg
%  Comment updates
%
%  Revision 1.3  2005/05/06 22:05:57  rickg
%  Comment updates
%
%  Revision 1.2  2004/09/18 00:00:28  rickg
%  Fixed zmax printing
%
%  Revision 1.1  2003/03/05 01:14:21  rickg
%  Initial revision
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
