%writeHeader    Write the header of an ImodModel
%
%   writeHeader(imodModel)
%
%   imodModel   The ImodModel object
%
%   Write out the ImodModel header to the current fid.
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/08 17:33:03 $
%
%  $Revision: 1.3 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function writeHeader(imodModel)

if isempty(imodModel.fid)
  error('ImodModel fid is empty')
end

tag = ['IMOD' imodModel.version];
writeAndCheck(imodModel.fid, tag, 'uchar');

nChar = length(imodModel.name);
nameStr = [imodModel.name zeros(1, 128-nChar)];
writeAndCheck(imodModel.fid, nameStr, 'uchar');

% Write out the header data
writeAndCheck(imodModel.fid, imodModel.xMax, 'int32');
 
writeAndCheck(imodModel.fid, imodModel.yMax, 'int32');
writeAndCheck(imodModel.fid, imodModel.zMax, 'int32');
writeAndCheck(imodModel.fid, imodModel.nObjects, 'int32');
writeAndCheck(imodModel.fid, imodModel.flags, 'uint32');
writeAndCheck(imodModel.fid, imodModel.drawMode, 'int32');
writeAndCheck(imodModel.fid, imodModel.mouseMode, 'int32');
writeAndCheck(imodModel.fid, imodModel.blackLevel, 'int32');
writeAndCheck(imodModel.fid, imodModel.whiteLevel, 'int32');
writeAndCheck(imodModel.fid, imodModel.xOffset, 'float32');
writeAndCheck(imodModel.fid, imodModel.yOffset, 'float32');
writeAndCheck(imodModel.fid, imodModel.zOffset, 'float32');
writeAndCheck(imodModel.fid, imodModel.xScale, 'float32');
writeAndCheck(imodModel.fid, imodModel.yScale, 'float32');
writeAndCheck(imodModel.fid, imodModel.zScale, 'float32');
writeAndCheck(imodModel.fid, imodModel.object, 'int32');
writeAndCheck(imodModel.fid, imodModel.contour, 'int32');
writeAndCheck(imodModel.fid, imodModel.point, 'int32');
writeAndCheck(imodModel.fid, imodModel.res, 'int32');
writeAndCheck(imodModel.fid, imodModel.thresh, 'int32');
writeAndCheck(imodModel.fid, imodModel.pixelSize, 'float32');
writeAndCheck(imodModel.fid, imodModel.units, 'int32');
writeAndCheck(imodModel.fid, imodModel.csum, 'int32');
writeAndCheck(imodModel.fid, imodModel.alpha, 'int32');
writeAndCheck(imodModel.fid, imodModel.beta, 'int32');
writeAndCheck(imodModel.fid, imodModel.gamma, 'int32');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: writeHeader.m,v $
%  Revision 1.3  2005/05/08 17:33:03  rickg
%  Comment update
%
%  Revision 1.2  2004/09/18 20:47:13  rickg
%  Help update
%
%  Revision 1.1  2004/09/18 00:02:41  rickg
%  Initial revision
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
