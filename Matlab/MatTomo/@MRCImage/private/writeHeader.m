%writeHeader    Write out the MRC file header
%
%   mRCImage = writeHeader(mRCImage, debug)
%
%   mRCImage    The MRCImage object
%
%   debug       OPTIONAL: Set to non-zero to get debugging output (default:0)
%
%   Write out the header contained in the returned MRCImage object to the file
%   specified by that object.
%
%   Calls: none
%
%   Bugs: none known

% TODO:
% - implement Extra section correctly for BL3DFS
% - implement MRC reading

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 18:44:40 $
%
%  $Revision: 1.7 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [mRCImage] = writeHeader(mRCImage, debug)

if nargin < 2
  debug = 0;
end
debugFD = 2;

if debug
  fprintf(debugFD, 'Writing first 3 variables\n');
end

% Check the permissions on the file ID, reopen it if needed
mRCImage.fid = openWritable(mRCImage);

% Return to the beginning of the file
status = fseek(mRCImage.fid, 0, 'bof');
if status
  disp('Could not move the file pointer to the begining ');
  error(ferror(mRCImage.fid));
end

% Write out the dimensions of the data
writeAndCheck(mRCImage.fid, mRCImage.header.nX, 'int32');
writeAndCheck(mRCImage.fid, mRCImage.header.nY, 'int32');
writeAndCheck(mRCImage.fid, mRCImage.header.nZ, 'int32');
writeAndCheck(mRCImage.fid, mRCImage.header.mode, 'int32');
writeAndCheck(mRCImage.fid, mRCImage.header.nXStart, 'int32');
writeAndCheck(mRCImage.fid, mRCImage.header.nYStart, 'int32');
writeAndCheck(mRCImage.fid, mRCImage.header.nZStart, 'int32');
writeAndCheck(mRCImage.fid, mRCImage.header.mX, 'int32');
writeAndCheck(mRCImage.fid, mRCImage.header.mY, 'int32');
writeAndCheck(mRCImage.fid, mRCImage.header.mZ, 'int32');
writeAndCheck(mRCImage.fid, mRCImage.header.cellDimensionX, 'float32');
writeAndCheck(mRCImage.fid, mRCImage.header.cellDimensionY, 'float32');
writeAndCheck(mRCImage.fid, mRCImage.header.cellDimensionZ, 'float32');
writeAndCheck(mRCImage.fid, mRCImage.header.cellAngleX, 'float32');
writeAndCheck(mRCImage.fid, mRCImage.header.cellAngleY, 'float32');
writeAndCheck(mRCImage.fid, mRCImage.header.cellAngleZ, 'float32');
writeAndCheck(mRCImage.fid, mRCImage.header.mapColumns, 'int32');
writeAndCheck(mRCImage.fid, mRCImage.header.mapRows, 'int32');
writeAndCheck(mRCImage.fid, mRCImage.header.mapSections, 'int32');
writeAndCheck(mRCImage.fid, mRCImage.header.minDensity, 'float32');
writeAndCheck(mRCImage.fid, mRCImage.header.maxDensity, 'float32');
writeAndCheck(mRCImage.fid, mRCImage.header.meanDensity, 'float32');

if(strcmp(mRCImage.type, 'MRC-2K') == 1)
  if debug
    fprintf(debugFD, 'Writing MRC-2K header\n');
  end

  writeAndCheck(mRCImage.fid, mRCImage.header.spaceGroup, 'int32');
  writeAndCheck(mRCImage.fid, mRCImage.header.nSymmetryBytes, 'int32');
  writeAndCheck(mRCImage.fid, mRCImage.header.extra, 'uchar');
  writeAndCheck(mRCImage.fid, mRCImage.header.xOrigin, 'int32');
  writeAndCheck(mRCImage.fid, mRCImage.header.yOrigin, 'int32');
  writeAndCheck(mRCImage.fid, mRCImage.header.zOrigin, 'int32');
  writeAndCheck(mRCImage.fid, mRCImage.header.map, 'uchar');
  writeAndCheck(mRCImage.fid, mRCImage.header.machineStamp, 'int32');
  writeAndCheck(mRCImage.fid, mRCImage.header.densityRMS, 'float32');
end

if strcmp(mRCImage.type, 'BL3DFS') == 1
  if debug
    fprintf(debugFD, 'Writing BL3DFS header\n');
  end

  writeAndCheck(mRCImage.fid, mRCImage.header.spaceGroup, 'int16');
  writeAndCheck(mRCImage.fid, mRCImage.header.nSymmetryBytes, 'int16');
  writeAndCheck(mRCImage.fid, mRCImage.header.nBytesExtended, 'int32');
  % MRC EXTRA section
  writeAndCheck(mRCImage.fid, mRCImage.header.creatorID, 'int16');
  writeAndCheck(mRCImage.fid, blanks(30), 'uchar');
  
  writeAndCheck(mRCImage.fid, mRCImage.header.nBytesPerSection, 'int16');
  writeAndCheck(mRCImage.fid, mRCImage.header.serialEMType, 'int16');
  writeAndCheck(mRCImage.fid, blanks(28), 'uchar');

  writeAndCheck(mRCImage.fid, mRCImage.header.idtype, 'int16');
  writeAndCheck(mRCImage.fid, mRCImage.header.lens, 'int16');
  writeAndCheck(mRCImage.fid, mRCImage.header.ndl, 'int16');
  writeAndCheck(mRCImage.fid, mRCImage.header.nd2, 'int16');
  writeAndCheck(mRCImage.fid, mRCImage.header.vdl, 'int16');
  writeAndCheck(mRCImage.fid, mRCImage.header.vd2, 'int16');
  writeAndCheck(mRCImage.fid, mRCImage.header.triangles, 'float32');

  % The BL3DFS header has two formats best distinguished by
  % detecting the 'MAP ' character sequence for the newer.
  if strncmp(mRCImage.header.map, 'MAP ', 4) 
    if debug
      fprintf(debugFD, 'Writing a new BL3DFS-MRC header\n');
    end
    writeAndCheck(mRCImage.fid, mRCImage.header.xOrigin, 'float32');
    writeAndCheck(mRCImage.fid, mRCImage.header.yOrigin, 'float32');
    writeAndCheck(mRCImage.fid, mRCImage.header.zOrigin, 'float32');
    writeAndCheck(mRCImage.fid, mRCImage.header.map, 'uchar');
    writeAndCheck(mRCImage.fid, mRCImage.header.machineStamp, 'uchar');  
    writeAndCheck(mRCImage.fid, mRCImage.header.densityRMS, 'float32');
  else
    if debug
      fprintf(debugFD, 'Writing an old BL3DFS-MRC header\n');
    end
    writeAndCheck(mRCImage.fid, mRCImage.header.nwave, 'int16');
    writeAndCheck(mRCImage.fid, mRCImage.header.wave1, 'int16');
    writeAndCheck(mRCImage.fid, mRCImage.header.wave2, 'int16');
    writeAndCheck(mRCImage.fid, mRCImage.header.wave3, 'int16');
    writeAndCheck(mRCImage.fid, mRCImage.header.wave4, 'int16');    
    writeAndCheck(mRCImage.fid, mRCImage.header.wave5, 'int16');
    writeAndCheck(mRCImage.fid, mRCImage.header.xOrigin, 'float32');
    writeAndCheck(mRCImage.fid, mRCImage.header.yOrigin, 'float32');
    writeAndCheck(mRCImage.fid, mRCImage.header.zOrigin, 'float32');
  end
end

% Write out the label data and skip blank labels 
writeAndCheck(mRCImage.fid, mRCImage.header.nLabels, 'int32');

for iLabel = 1:mRCImage.header.nLabels
  writeAndCheck(mRCImage.fid, mRCImage.header.labels(iLabel,:), 'uchar');
end

for iJunk = mRCImage.header.nLabels+1:10
  writeAndCheck(mRCImage.fid, blanks(80), 'uchar');
end

% Read in the extended header if this is a BL3DFS file
if strcmp(mRCImage.type, 'BL3DFS') == 1
  writeAndCheck(mRCImage.fid, mRCImage.extended, 'uchar');
end

return

% Simple error checking write
function writeAndCheck(fid, matrix, precision)
nElements = prod(size(matrix));
count = fwrite(fid, matrix, precision);
if count ~= nElements
  fprintf('Matrix contains %d but only wrote %d elements\n', nElements, count);
  error('Unsuccessful writing matrix');
end
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: writeHeader.m,v $
%  Revision 1.7  2005/05/09 18:44:40  rickg
%  Comment updates
%
%  Revision 1.6  2004/07/17 16:25:43  rickg
%  Put fid into MRCImage object
%
%  Revision 1.5  2004/07/14 22:43:09  rickg
%  Moved reopening into openWritable
%
%  Revision 1.4  2004/07/01 23:11:47  rickg
%  Open a new file (fid == []) in w+
%
%  Revision 1.3  2004/06/01 16:08:31  rickg
%  Open file with correct endian format
%
%  Revision 1.2  2004/04/28 05:02:17  rickg
%  Removed debugging code
%
%  Revision 1.1  2004/03/20 00:18:40  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
