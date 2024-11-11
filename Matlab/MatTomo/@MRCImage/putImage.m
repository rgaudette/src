%putImage       Replace the specified image of a MRCImage object
%
%   mRCImage = putImage(mRCImage, img, index)
%
%   img         The specified image as a 2D array
%
%   mRCImage    The MRCImage object containing the stack of interest
%
%   index       The index of the image to replace, indices start at 1.
%
%
%   Replaces the specifed image in the MRCImage object.
%
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 18:44:40 $
%
%  $Revision: 1.6 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mRCImage = putImage(mRCImage, img, index)

% Error checking
if index < 1
  error('Image index out of range');
end

[nX nY] = size(img);
if nX ~= mRCImage.header.nX
  fprintf('Image size: %d x %d\n', nX, nY);
  fprintf('Stack image size: %d x %d\n', ...
          mRCImage.header.nX,  mRCImage.header.nY);
  error('Image is not the same size as the stack');
end
if nY ~= mRCImage.header.nY
  fprintf('Image size: %d x %d\n', nX, nY);
  fprintf('Stack image size: %d x %d\n', ...
          mRCImage.header.nX,  mRCImage.header.nY);
  error('Image is not the same size as the stack');
end

if mRCImage.flgVolume
  mRCImage.volume(:,:, index) = img;
else
  % Check the permissions on the file ID, reopen it if needed
  mRCImage.fid = openWritable(mRCImage);
    
  % Move the file pointer to the beginning requested image
  nImageElements = mRCImage.header.nX * mRCImage.header.nY;
  nImageBytes = nImageElements * getModeBytes(mRCImage);
  idxDataStart = mRCImage.dataIndex + (index - 1) * nImageBytes;
  moveOrExtendFP(mRCImage.fid, idxDataStart, idxDataStart + nImageBytes);
  
  % Write out the image from the MRC file
  count = fwrite(mRCImage.fid, double(img), getModeString(mRCImage));
  if count ~= nImageElements
    ferror(mRCImage.fid)
    error(['Expected ' int2str(nImageElements) ' elements, wrote ' ...
           int2str(count)]);
  end
  
  % Update the header if slice is greater than the current number of
  % slice in the header
  if index > mRCImage.header.nZ
    mRCImage.header.nZ = index;
    mRCImage = writeHeader(mRCImage);
  end
end


function moveOrExtendFP(fid, index, totalSize)

status = fseek(fid, index, 'bof');

if status
  [message errno] = ferror(fid);
  if errno == -27
    %  Seek to the end of the file
    stat2 = fseek(fid, 0, 'eof');
    if stat2
      disp('Could not seek to the end of the existing file');
      error(ferror(fid));
    end
    
    % Write out enough zeros to extend the file
    pos = ftell(fid);
    nZeros = totalSize - pos;
    count = fwrite(fid, zeros(nZeros, 1), 'uchar');
    if count ~= nZeros
      disp('Unable to extend file');
      error(ferror(fid));
    end
    
    % Attempt to move the file pointer again
    stat3 = fseek(fid, index, 'bof');
    if stat3
      disp('Could not move the file pointer after extending file');
      error(ferror(fid));
    end
  else
    error(ferror(fid));
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: putImage.m,v $
%  Revision 1.6  2005/05/09 18:44:40  rickg
%  Comment updates
%
%  Revision 1.5  2004/08/31 23:31:59  rickg
%  Fixed help description
%  Correctly access fid in the mRCImage structure
%
%  Revision 1.4  2004/07/14 22:56:37  rickg
%  Moved file reopening to openWritable
%
%  Revision 1.3  2004/03/20 00:25:20  rickg
%  Allow write images past the end of the file
%  Restructure file re/opening
%
%  Revision 1.2  2004/03/09 19:23:41  rickg
%  Only close file if fid changes.
%
%  Revision 1.1  2004/03/08 23:19:46  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
