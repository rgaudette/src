%default        Default MRCImage file structure
%
%   mRCImage = default
%
%   mRCImage    The MRCImage object structure.
%
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 18:44:40 $
%
%  $Revision: 1.5 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mRCImage = default

mRCImage.fid = [];
mRCImage.filename = [];
mRCImage.endianFormat = 'ieee-le';
mRCImage.type = 'BL3DFS';
mRCImage.version = '1.0';

mRCImage.dataIndex = -Inf;
mRCImage.volume = [];
mRCImage.flgVolume = 0;

mRCImage.header.nX = -Inf;
mRCImage.header.nY = -Inf;
mRCImage.header.nZ = -Inf;
mRCImage.header.mode = -Inf;
mRCImage.header.nXStart = -Inf;
mRCImage.header.nYStart = -Inf;
mRCImage.header.nZStart = -Inf;
mRCImage.header.mX = -Inf;
mRCImage.header.mY = -Inf;
mRCImage.header.mZ = -Inf;
mRCImage.header.cellDimensionX = -Inf;
mRCImage.header.cellDimensionY = -Inf;
mRCImage.header.cellDimensionZ = -Inf;
mRCImage.header.cellAngleX = -Inf;
mRCImage.header.cellAngleY = -Inf;
mRCImage.header.cellAngleZ = -Inf;
mRCImage.header.mapColumns = 1;
mRCImage.header.mapRows = 2;
mRCImage.header.mapSections = 3;
mRCImage.header.minDensity = -Inf;
mRCImage.header.maxDensity = -Inf;
mRCImage.header.meanDensity = -Inf;
mRCImage.header.spaceGroup = -Inf;
mRCImage.header.nSymmetryBytes = -Inf;
mRCImage.header.nBytesExtended = -Inf;
mRCImage.header.creatorID = -Inf;
mRCImage.header.nBytesPerSection = -Inf;
mRCImage.header.serialEMType = -Inf;
mRCImage.header.idtype = -Inf;
mRCImage.header.lens = -Inf;
mRCImage.header.ndl = -Inf;
mRCImage.header.nd2 = -Inf;
mRCImage.header.vdl = -Inf;
mRCImage.header.vd2 = -Inf;
mRCImage.header.nwave = -Inf;
mRCImage.header.wave1 = -Inf;
mRCImage.header.wave2 = -Inf;
mRCImage.header.wave3 = -Inf;
mRCImage.header.wave4 = -Inf;
mRCImage.header.wave5 = -Inf;
mRCImage.header.triangles = [];
mRCImage.header.extra = [];
mRCImage.header.xOrigin = -Inf;
mRCImage.header.yOrigin = -Inf;
mRCImage.header.zOrigin = -Inf;
mRCImage.header.map = '';
mRCImage.header.machineStamp = '';
mRCImage.header.densityRMS = -Inf;
mRCImage.header.nLabels = -Inf;
mRCImage.header.labels = [blanks(80); blanks(80); 
                    blanks(80); blanks(80); 
                    blanks(80); blanks(80);
                    blanks(80); blanks(80);
                    blanks(80); blanks(80) ];

mRCImage.extended = [];

return 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: default.m,v $
%  Revision 1.5  2005/05/09 18:44:40  rickg
%  Comment updates
%
%  Revision 1.4  2003/06/13 22:06:00  rickg
%  Changed name of struct to mRCImage
%
%  Revision 1.3  2003/02/14 23:41:13  rickg
%  Added volume member and flag to identify if the volume has been loaded
%
%  Revision 1.2  2003/01/02 18:22:55  rickg
%  Changed map and machineStamp to empty strings
%  Added and extended empty array
%
%  Revision 1.1.1.1  2002/12/14 07:28:50  rickg
%  Initial Revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
