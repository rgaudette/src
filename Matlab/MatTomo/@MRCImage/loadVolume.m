%loadVolume     Attempt to load the complete data volume into memory
%
%   mRCImage = loadVolume(mRCImage, debug)
%
%   mRCImage    The opened MRCImage object
%
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 18:44:40 $
%
%  $Revision: 1.2 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mRCImage = loadVolume(mRCImage)


% Move the file pointer to the start of the volume data
if fseek(mRCImage.fid, mRCImage.dataIndex, 'bof')
  error(ferror(mRCImage.fid));
end

nVoxels = mRCImage.header.nX * mRCImage.header.nY * mRCImage.header.nZ;
[mRCImage.volume count]= fread(mRCImage.fid, nVoxels, getModeString(mRCImage));
if count ~= nVoxels
  error('Could not read complete volume');
end

mRCImage.flgVolume = 1;

mRCImage.volume = reshape(mRCImage.volume, ...
                          mRCImage.header.nX, ...
                          mRCImage.header.nY, ...
                          mRCImage.header.nZ);

                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: loadVolume.m,v $
%  Revision 1.2  2005/05/09 18:44:40  rickg
%  Comment updates
%
%  Revision 1.1  2003/02/14 23:56:33  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%