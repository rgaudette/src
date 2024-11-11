%writeHeader    Write the header of an ImodObject
%
%   writeHeader(imodObject, fid)
%
%   imodObject  The ImodObject
%
%   fid         A file ID of an open file with the pointer at the start of an
%               IMOD Object object.
%
%   Write out the ImodObject header to the specified fid.
%   
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 15:46:55 $
%
%  $Revision: 1.2 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function writeHeader(imodObject, fid)

writeAndCheck(fid, 'OBJT', 'uchar');

nChar = length(imodObject.name);
nameStr = [imodObject.name zeros(1, 128-nChar)];
writeAndCheck(fid, nameStr, 'uchar');

writeAndCheck(fid, imodObject.nContours, 'int32');
writeAndCheck(fid, imodObject.flags, 'int32');
writeAndCheck(fid, imodObject.axis, 'int32');
writeAndCheck(fid, imodObject.drawMode, 'int32');
writeAndCheck(fid, imodObject.red, 'float32');
writeAndCheck(fid, imodObject.green, 'float32');
writeAndCheck(fid, imodObject.blue, 'float32');
writeAndCheck(fid, imodObject.pdrawsize, 'int32');

writeAndCheck(fid, imodObject.symbol, 'uchar');
writeAndCheck(fid, imodObject.symbolSize, 'uchar');
writeAndCheck(fid, imodObject.lineWidth2D, 'uchar');
writeAndCheck(fid, imodObject.lineWidth3D, 'uchar');
writeAndCheck(fid, imodObject.lineStyle, 'uchar');
writeAndCheck(fid, imodObject.symbolFlags, 'uchar');
writeAndCheck(fid, imodObject.sympad, 'uchar');
writeAndCheck(fid, imodObject.transparency, 'uchar');

writeAndCheck(fid, imodObject.nMeshes, 'int32');
writeAndCheck(fid, imodObject.nSurfaces, 'int32');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: writeHeader.m,v $
%  Revision 1.2  2005/05/09 15:46:55  rickg
%  *** empty log message ***
%
%  Revision 1.1  2004/09/17 23:57:12  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
