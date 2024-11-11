%getImage       Get the specified image out of the MRCImage
%
%   img = getImage(mRCImage, index)
%
%   img         The specified image as a 2D array
%
%   mRCImage    The MRCImage object containing the stack of interest
%
%   index       The index of the image to extract, indices start at 1.
%
%
%   Return the specifed image from the MRCImage object.
%
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 17:47:04 $
%
%  $Revision: 1.7 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function img = getImage(mRCImage, index)

if index < 1 | index > mRCImage.header.nZ
  error('Image index out of range');
end

if mRCImage.flgVolume
  img = mRCImage.volume(:,:, index);
else
  % Move the file pointer to the requested image
  nImageElements = mRCImage.header.nX * mRCImage.header.nY;
  idxDataStart = mRCImage.dataIndex + (index - 1) * nImageElements * ...
    getModeBytes(mRCImage);
  precision = [getModeString(mRCImage) '=>' getModeString(mRCImage)];
  fseek(mRCImage.fid, idxDataStart, 'bof');
  
  % Read in the image from the MRC file
  [img count] = fread(mRCImage.fid, nImageElements, precision);
  if count ~= nImageElements
    error(['Expected ' int2str(nImageElements) ' elements, read ' ...
           int2str(count)]);
  end

  % Reshape the image to match nX and nY
  img = reshape(img, mRCImage.header.nX, mRCImage.header.nY);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: getImage.m,v $
%  Revision 1.7  2005/05/09 17:47:04  rickg
%  Comment updates
%
%  Revision 1.6  2003/11/17 06:17:35  rickg
%  Added the functionality to get the image from disk when the volume is not
%  loaded.
%
%  Revision 1.5  2003/06/17 14:12:02  rickg
%  Volume is currently always loaded now
%
%  Revision 1.4  2003/02/14 23:44:19  rickg
%  Changed or operator to short-circuit
%
%  Revision 1.3  2003/01/09 00:08:25  rickg
%  Fixed mRCImage name and fixed projection index range
%
%  Revision 1.2  2002/12/27 15:02:51  rickg
%  In progress
%
%  Revision 1.1.1.1  2002/12/14 07:28:50  rickg
%  Initial Revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
