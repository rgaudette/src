%readHeader     Read in the MRC file header
%
%   mRCImage = readHeader(mRCImage, debug)
%
%   mRCImage    The constructed MRCImage object
%
%   debug       OPTIONAL: Set to non-zero to get debugging output (default:0)
%
%   Read the header into the returned MRCImage object
%
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
%  $Revision: 1.8 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [mRCImage] = readHeader(mRCImage, debug)

if nargin < 2
  debug = 0;
end
debugFD = 2;

if debug
  fprintf(debugFD, 'Reading first 3 variables\n');
end
  
%  Read in the dimensions of the data
mRCImage.header.nX = fread(mRCImage.fid, 1, 'int32');
mRCImage.header.nY = fread(mRCImage.fid, 1, 'int32');
mRCImage.header.nZ = fread(mRCImage.fid, 1, 'int32');


if debug
  fprintf(debugFD, 'Checking endian formtat\n');
end

%  Check to see if the bytes need to be swapped, reopen the file in the
%  opposite format
if  mRCImage.header.nX > 20000 | mRCImage.header.nX < 0 | ...
    mRCImage.header.nY > 20000 | mRCImage.header.nY < 0 | ...
    mRCImage.header.nZ > 20000 | mRCImage.header.nZ < 0

  if debug
    fprintf(debugFD, 'Non-native endian format, swapping\n');
  end

  [fname perm fileEndianFormat] = fopen(mRCImage.fid);
 
  if strcmp('ieee-be', fileEndianFormat) == 1
    mRCImage.endianFormat = 'ieee-le';
  else
    mRCImage.endianFormat = 'ieee-be';
  end

  if debug
    fprintf(debugFD, 'File format %s, attempting to open as %s\n', ...
            fileEndianFormat, mRCImage.endianFormat)
  end

  fclose(mRCImage.fid);
  [mRCImage.fid message] = fopen(mRCImage.filename, 'r', ...
                                 mRCImage.endianFormat);

  % reread the data dimensions in the correct endian format
  mRCImage.header.nX = fread(mRCImage.fid, 1, 'int32');
  mRCImage.header.nY = fread(mRCImage.fid, 1, 'int32');
  mRCImage.header.nZ = fread(mRCImage.fid, 1, 'int32');
else 
  if debug
    fprintf(debugFD, 'Native endian format.\n');
  end
end


if debug
  fprintf(debugFD, 'nX: %d\n', mRCImage.header.nX);
  fprintf(debugFD, 'nY: %d\n', mRCImage.header.nY);
  fprintf(debugFD, 'nZ: %d\n', mRCImage.header.nZ);
  fprintf(debugFD, 'Reading invariant header\n');
end

mRCImage.header.mode = fread(mRCImage.fid, 1, 'int32');
mRCImage.header.nXStart = fread(mRCImage.fid, 1, 'int32');
mRCImage.header.nYStart = fread(mRCImage.fid, 1, 'int32');
mRCImage.header.nZStart = fread(mRCImage.fid, 1, 'int32');
mRCImage.header.mX = fread(mRCImage.fid, 1, 'int32');
mRCImage.header.mY = fread(mRCImage.fid, 1, 'int32');
mRCImage.header.mZ = fread(mRCImage.fid, 1, 'int32');
mRCImage.header.cellDimensionX = fread(mRCImage.fid, 1, 'float32');
mRCImage.header.cellDimensionY = fread(mRCImage.fid, 1, 'float32');
mRCImage.header.cellDimensionZ = fread(mRCImage.fid, 1, 'float32');
mRCImage.header.cellAngleX = fread(mRCImage.fid, 1, 'float32');
mRCImage.header.cellAngleY = fread(mRCImage.fid, 1, 'float32');
mRCImage.header.cellAngleZ = fread(mRCImage.fid, 1, 'float32');
mRCImage.header.mapColumns = fread(mRCImage.fid, 1, 'int32');
mRCImage.header.mapRows = fread(mRCImage.fid, 1, 'int32');
mRCImage.header.mapSections = fread(mRCImage.fid, 1, 'int32');
mRCImage.header.minDensity = fread(mRCImage.fid, 1, 'float32');
mRCImage.header.maxDensity = fread(mRCImage.fid, 1, 'float32');
mRCImage.header.meanDensity = fread(mRCImage.fid, 1, 'float32');


if(strcmp(mRCImage.type, 'MRC-2K') == 1)
  if debug
    fprintf(debugFD, 'Reading MRC-2K header\n');
  end

  mRCImage.header.spaceGroup = fread(mRCImage.fid, 1, 'int32');
  mRCImage.header.nSymmetryBytes = fread(mRCImage.fid, 1, 'int32');
  mRCImage.header.extra = fread(mRCImage.fid, 25*4, 'uchar');

  mRCImage.header.xOrigin = fread(mRCImage.fid, 1, 'int32');
  mRCImage.header.yOrigin = fread(mRCImage.fid, 1, 'int32');
  mRCImage.header.zOrigin = fread(mRCImage.fid, 1, 'int32');
  mRCImage.header.map = char(fread(mRCImage.fid, 4, 'uchar'));
  mRCImage.header.machineStamp = fread(mRCImage.fid, 4, 'int32');
  mRCImage.header.densityRMS = fread(mRCImage.fid, 1, 'float32');
end

if strcmp(mRCImage.type, 'BL3DFS') == 1
  if debug
    fprintf(debugFD, 'Reading BL3DFS header\n');
  end

  mRCImage.header.spaceGroup = fread(mRCImage.fid, 1, 'int16');
  mRCImage.header.nSymmetryBytes = fread(mRCImage.fid, 1, 'int16');
  if debug
    fprintf(debugFD, 'nSymmetry bytes %d\n', mRCImage.header.nSymmetryBytes);
  end

  mRCImage.header.nBytesExtended = fread(mRCImage.fid, 1, 'int32');
  if debug
    fprintf(debugFD, 'nBytesExtended %d\n', mRCImage.header.nBytesExtended);
  end

  % MRC EXTRA section
  mRCImage.header.creatorID = fread(mRCImage.fid, 1, 'int16');

  junk = fread(mRCImage.fid, 30, 'uchar');
  
  mRCImage.header.nBytesPerSection = fread(mRCImage.fid, 1, 'int16');
  if debug
    fprintf(debugFD, 'nBytesPerSection %d\n', ...
            mRCImage.header.nBytesPerSection);
  end

  mRCImage.header.serialEMType = fread(mRCImage.fid, 1, 'int16');
  if debug
    fprintf(debugFD, 'serialEMType %d\n', ...
            mRCImage.header.serialEMType);
  end

  junk = fread(mRCImage.fid, 28, 'uchar');  

  mRCImage.header.idtype = fread(mRCImage.fid, 1, 'int16');
  mRCImage.header.lens = fread(mRCImage.fid, 1, 'int16');
  mRCImage.header.ndl = fread(mRCImage.fid, 1, 'int16');
  mRCImage.header.nd2 = fread(mRCImage.fid, 1, 'int16');
  mRCImage.header.vdl = fread(mRCImage.fid, 1, 'int16');
  mRCImage.header.vd2 = fread(mRCImage.fid, 1, 'int16');
  mRCImage.header.triangles(1) = fread(mRCImage.fid, 1, 'float32');
  mRCImage.header.triangles(2) = fread(mRCImage.fid, 1, 'float32');
  mRCImage.header.triangles(3) = fread(mRCImage.fid, 1, 'float32');
  mRCImage.header.triangles(4) = fread(mRCImage.fid, 1, 'float32');
  mRCImage.header.triangles(5) = fread(mRCImage.fid, 1, 'float32');
  mRCImage.header.triangles(6) = fread(mRCImage.fid, 1, 'float32');

  % The BL3DFS header has two formats best distinguished by
  % detecting the 'MAP ' character sequence for the newer.
  if fseek(mRCImage.fid, 12, 'cof')
    error(ferror(mRCImage.fid));
  end
  cmap = char(fread(mRCImage.fid, 4, 'uchar'));
  if debug
    fprintf(debugFD, 'Map string: "%s"\n', cmap);
  end
  
  % Seek back to the beginning of this section
  if fseek(mRCImage.fid, -16, 'cof')
    error(ferror(mRCImage.fid));
  end
  
  if strncmp(cmap, 'MAP ', 4) 
    if debug
      fprintf(debugFD, 'Found a new BL3DFS-MRC header\n');
    end
    mRCImage.header.xOrigin = fread(mRCImage.fid, 1, 'float32');
    mRCImage.header.yOrigin = fread(mRCImage.fid, 1, 'float32');
    mRCImage.header.zOrigin = fread(mRCImage.fid, 1, 'float32');
    mRCImage.header.map = char(fread(mRCImage.fid, 4, 'uchar'));
    mRCImage.header.machineStamp = char(fread(mRCImage.fid, 4, 'uchar'));  
    mRCImage.header.densityRMS = fread(mRCImage.fid, 1, 'float32');
    
    % Make sure the old fields are empty
    mRCImage.header.nwave = -Inf;
    mRCImage.header.wave1 = -Inf;
    mRCImage.header.wave2 = -Inf;
    mRCImage.header.wave3 = -Inf;
    mRCImage.header.wave4 = -Inf;
    mRCImage.header.wave5 = -Inf; 
  else
    if debug
      fprintf(debugFD, 'Found an old BL3DFS-MRC header\n');
    end
    mRCImage.header.nwave = fread(mRCImage.fid, 1, 'int16');
    mRCImage.header.wave1 = fread(mRCImage.fid, 1, 'int16');
    mRCImage.header.wave2 = fread(mRCImage.fid, 1, 'int16');
    mRCImage.header.wave3 = fread(mRCImage.fid, 1, 'int16');
    mRCImage.header.wave4 = fread(mRCImage.fid, 1, 'int16');    
    mRCImage.header.wave5 = fread(mRCImage.fid, 1, 'int16');
    mRCImage.header.xOrigin = fread(mRCImage.fid, 1, 'float32');
    mRCImage.header.yOrigin = fread(mRCImage.fid, 1, 'float32');
    mRCImage.header.zOrigin = fread(mRCImage.fid, 1, 'float32');

    % Make sure the new header fields are empty
    mRCImage.header.map = '';
    mRCImage.header.machineStamp = '';
    mRCImage.header.densityRMS = -Inf;
  end

end

% Read in the label data and skip blank labels 
mRCImage.header.nLabels = fread(mRCImage.fid, 1, 'int32');
if debug
  fprintf(debugFD, 'Reading %d labels\n', mRCImage.header.nLabels);
end


for iLabel = 1:mRCImage.header.nLabels
  mRCImage.header.labels(iLabel,:) = char(fread(mRCImage.fid, 80, 'uchar'));
  if debug
    fprintf(debugFD, '%s\n', mRCImage.header.labels(iLabel,:));
  end
end

for iJunk = mRCImage.header.nLabels+1:10
  junk = fread(mRCImage.fid, 80, 'uchar=>uchar'); 
end

% Read in the extended header if this is a BL3DFS file
if strcmp(mRCImage.type, 'BL3DFS') == 1
  mRCImage.extended = ...
      fread(mRCImage.fid, mRCImage.header.nBytesExtended, 'uchar=>uchar');
end

% Set the image data starting point
mRCImage.dataIndex = 1024 + mRCImage.header.nBytesExtended;

if debug
  % display the nubmer of bytes in the file

  nFileBytes = getFileNBytes(mRCImage);

  fprintf(debugFD, 'File contains %d bytes\n', nFileBytes);

  fprintf(debugFD, 'MRC Header length: 1024\n');

  fprintf(debugFD, 'Extended header length: %d\n', ...
          mRCImage.header.nBytesExtended);

  dataBytes = mRCImage.header.nX  * mRCImage.header.nY ...
      * mRCImage.header.nZ * getModeBytes(mRCImage);

  fprintf(debugFD, 'Data bytes: %d\n', dataBytes);
  fprintf(debugFD, 'Difference: %d\n' , nFileBytes - 1024 - dataBytes - ...
          mRCImage.header.nBytesExtended);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: readHeader.m,v $
%  Revision 1.8  2005/05/09 18:44:40  rickg
%  Comment updates
%
%  Revision 1.7  2004/04/28 05:01:54  rickg
%  Fixed call to get fid
%
%  Revision 1.6  2004/03/20 00:19:35  rickg
%  Comment addition
%
%  Revision 1.5  2004/03/08 23:23:10  rickg
%  Explicit read-only open
%
%  Revision 1.4  2004/01/05 01:47:28  rickg
%  Added help commments
%
%  Revision 1.3  2003/01/02 18:20:55  rickg
%  Implemented new BL3DFS header
%  had to use strncmp instead of strcmp for 'MAP ' detection
%  Use the nBytesExtended field to calculate the image starting point
%
%  Revision 1.2  2002/12/27 15:07:04  rickg
%  Added debugging capability
%  Corrected for missed endian detection where the data dimensions were read
%  as negative numbers.
%
%  Revision 1.1.1.1  2002/12/14 07:28:50  rickg
%  Initial Revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
