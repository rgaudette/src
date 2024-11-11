%showHeader     Display the mRCImage header
%
%   showHeader(mRCImage)
%
%   mRCImage    The MRCImage object.
%
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 18:44:40 $
%
%  $Revision: 1.4 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function showHeader(mRCImage)

fprintf('# X:\t\t\t\t%d\n', mRCImage.header.nX);
fprintf('# Y:\t\t\t\t%d\n', mRCImage.header.nY);
fprintf('# Z:\t\t\t\t%d\n', mRCImage.header.nZ);
fprintf('mode:\t\t\t\t%d\n', mRCImage.header.mode);  
fprintf('X start:\t\t\t%d\n', mRCImage.header.nXStart);
fprintf('Y start:\t\t\t%d\n', mRCImage.header.nYStart);
fprintf('Z start:\t\t\t%d\n', mRCImage.header.nZStart);
fprintf('X intervals:\t\t\t%d\n', mRCImage.header.mX);
fprintf('Y intervals:\t\t\t%d\n', mRCImage.header.mY);
fprintf('Z intervals:\t\t\t%d\n', mRCImage.header.mZ);

fprintf('cell dimension X:\t\t%d angstroms\n', ...
        mRCImage.header.cellDimensionX);
fprintf('cell dimension Y:\t\t%d angstroms\n', ...
        mRCImage.header.cellDimensionY);
fprintf('cell dimension Z:\t\t%d angstroms\n', ...
        mRCImage.header.cellDimensionZ);  
fprintf('cell angle X:\t\t\t%d degrees\n', mRCImage.header.cellAngleX);
fprintf('cell angle Y:\t\t\t%d degrees\n', mRCImage.header.cellAngleY);
fprintf('cell angle Z:\t\t\t%d degrees\n', mRCImage.header.cellAngleZ);  

mapTable = ['X' 'Y' 'Z'];
fprintf('columns map to:\t\t\t%s\n', ...
        mapTable(mRCImage.header.mapColumns));
fprintf('rows map to:\t\t\t%s\n',  ...
        mapTable(mRCImage.header.mapRows));
fprintf('sections map to:\t\t%s\n',  ...
        mapTable(mRCImage.header.mapSections));

fprintf('minimum density:\t\t%d\n', mRCImage.header.minDensity);
fprintf('maximum density:\t\t%d\n', mRCImage.header.maxDensity);
fprintf('mean density:\t\t\t%d\n', mRCImage.header.meanDensity);
fprintf('rms density:\t\t\t%d\n', mRCImage.header.densityRMS);
fprintf('space group:\t\t\t%d\n', mRCImage.header.spaceGroup);

fprintf('# symmetry bytes:\t\t%d\n', mRCImage.header.nSymmetryBytes);

if(strcmp(mRCImage.type, 'MRC-2K') == 1)
  fprintf('Extra :\n');
  fprintf('%d ', mRCImage.header.extra);
  fprintf('\n');
end

if strcmp(mRCImage.type, 'BL3DFS') == 1
  fprintf('# extended header bytes:\t%d\n', ...
          mRCImage.header.nBytesExtended);
  fprintf('creator ID:\t\t\t%d\n', mRCImage.header.creatorID);
  fprintf('Bytes per section in extended header:\t%d\n', ...
          mRCImage.header.nBytesPerSection);
  fprintf('Serial EM data type:\t\t%d\n', mRCImage.header.serialEMType);
end

fprintf('X origin:\t\t\t%d\n', mRCImage.header.xOrigin);
fprintf('Y origin:\t\t\t%d\n', mRCImage.header.yOrigin);
fprintf('Z origin:\t\t\t%d\n', mRCImage.header.zOrigin);
if all(mRCImage.header.map > 0) & all(mRCImage.header.map < 255)
  fprintf('map : %s\n', mRCImage.header.map);
end

fprintf('machine stamp: %s\n', char(mRCImage.header.machineStamp));
fprintf('# labels:\t\t\t%d\n', mRCImage.header.nLabels);
for iLabel = 1:mRCImage.header.nLabels
   fprintf('%s\n', mRCImage.header.labels(iLabel,:));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: showHeader.m,v $
%  Revision 1.4  2005/05/09 18:44:40  rickg
%  Comment updates
%
%  Revision 1.3  2003/01/09 00:09:06  rickg
%  Check map field for a valid range before displaying
%
%  Revision 1.2  2002/12/27 15:05:07  rickg
%  In progress, need to match up with readHeader
%
%  Revision 1.1.1.1  2002/12/14 07:28:50  rickg
%  Initial Revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
