%setNZ          Resize the data by changing the number of sections (z planes)
%
%   mRCImage = setNZ(mRCImage, nZ)
%
%   mRCImage    The MRCImage object
%
%   nZ          The number of sections (z planes)
%
%   setNZ will set the number of sections (z planes) in the MRCImage object by
%   either truncating or expanding the data volume (or file, if the volume is
%   not loaded).  The nZ header value will also be correctly set.
%
%   Calls: relies on the external command truncate.
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

function mRCImage = setNZ(mRCImage, nZ)

if mRCImage.flgVolume
  mRCImage.volume = mRCImage.volume(:,:,1:nZ);
  mRCImage.header.nZ = nZ;
else
  % Calculate the total header size in bytes
  nHeaderBytes = 1024 + mRCImage.header.nBytesExtended;
  
  % Calculate the size of each section
  nBytesPerImage =  mRCImage.header.nX * mRCImage.header.nY * ...
      getModeBytes(mRCImage);
  nFileBytes = nHeaderBytes + nZ * nBytesPerImage;

  truncateCmd = ['truncate ' mRCImage.filename ' ' int2str(nFileBytes) ];
  [status result] = system(truncateCmd);
  disp(truncateCmd)
  if status
    error(result);
  end
  
  % Adjust the header and write it out to disk
  mRCImage.header.nZ = nZ
  mRCImage = writeHeader(mRCImage)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: setNZ.m,v $
%  Revision 1.2  2005/05/09 18:44:40  rickg
%  Comment updates
%
%  Revision 1.1  2004/03/20 00:23:56  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%