%zero           Zero the volume data in a MRCImage
%
%   mRCImage = zero(mRCImage)
%
%   mRCImage    The MRCImage object.
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 18:44:40 $
%
%  $Revision: 1.3 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mRCImage = zero(mRCImage)

%  Zero the volume data
if mRCImage.flgVolume
  modeString = getModeString(mRCImage);
  z = zeros(header.nY, header.nX, header.nZ);
  mRCImage.volume = feval(modeString, z);
else
  % Check the permissions on the file ID, reopen it if needed
  mRCImage.fid = openWritable(mRCImage);
  
  %  Move the data pointer to the start of the image data section of the
  %  file
  status = fseek(mRCImage.fid, mRCImage.dataIndex, 'bof');
  if status
    error(ferror(mRCImage.fid))
  end

  % Write out the correct number of zeros in image size chunks
  nImageElements = mRCImage.header.nX * mRCImage.header.nX;
  img = zeros(nImageElements, 1);
  for iSlice = 1:mRCImage.header.nZ
    count = fwrite(mRCImage.fid, img, getModeString(mRCImage));
    if count ~= nImageElements
      ferror(mRCImage.fid)
      error(['Expected ' int2str(nImageElements) ' elements, wrote ' ...
             int2str(count)]);
    end
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: zero.m,v $
%  Revision 1.3  2005/05/09 18:44:40  rickg
%  Comment updates
%
%  Revision 1.2  2004/07/14 22:50:58  rickg
%  Moved file reopening into openWritable
%
%  Revision 1.1  2004/03/17 00:36:26  rickg
%  Initial revision
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%