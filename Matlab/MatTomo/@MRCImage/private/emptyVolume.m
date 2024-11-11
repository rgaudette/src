%emptyVolume    Create a MRCImage with the supplied header and a zero volume
%
%   mRCImage = emptyVolume(mRCImage, header, filename, flgVolume)
%
%   mRCImage    The MRCImage object.
%
%   header      The MRCImage header to use in constructing the object.
%
%   filename    The filename to associate with this MRCImage object.
%
%   flgVolume   OPTIONAL: Set volume loaded flag for the new object. 
%
%
%   TEMPLATE Describe function, it's methods and results.
%
%   Calls: none
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

function mRCImage = emptyVolume(mRCImage, header, filename, flgVolume)

% TODO conditional field checking and error reporting
if nargin < 4
  mRCImage.flgVolume = 1;
else
  mRCImage.flgVolume = flgVolume;
end

if nargin > 2
  mRCImage.filename = filename;
else
  mRCImage.filename = [];
end

mRCImage.fid = [];
mRCImage.endianFormat = 'native';
mRCImage.type = 'BL3DFS';
mRCImage.version = '1.0';
mRCImage.dataIndex = 1024;

% Copy the given header
mRCImage.header = header;

% FIXME: how to deal with this
% Reset the extented header
mRCImage.extended = [];
mRCImage.header.nBytesExtended = 0;

% Reset the statistics
mRCImage.header.minDensity = 0.0;
mRCImage.header.maxDensity = 0.0;
mRCImage.header.meanDensity = 0.0;
mRCImage.header.densityRMS = 0.0;

%  Create a zeroed volume
mRCImage = zero(mRCImage);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: emptyVolume.m,v $
%  Revision 1.5  2005/05/09 18:44:40  rickg
%  Comment updates
%
%  Revision 1.4  2004/07/14 22:48:06  rickg
%  Call zero method now to zero out volume
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
