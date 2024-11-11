%save           Save the MRCImage object
%
%   mRCImage = save(mRCImage, newFilename);
%
%   mRCImage    The MRCImage object
%
%   newFilename OPTIONAL: Change the filename associated with this object and
%               save it to the new filename.
%
%
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 18:44:40 $
%
%  $Revision: 1.7 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mRCImage = save(mRCImage, newFilename);

%  FIXME: update logic
if nargin > 1
  mRCImage = close(mRCImage);
  mRCImage.filename = newFilename;
  % Check to see if the file exists
  result = dir(mRCImage.filename);
  if size(result, 1) > 0
    if result.isdir
      error('%s is a directory', newFilename);
    else
      % if the file exists it needs to move out of the way
      delete(mRCImage.filename);
    end
  end
end

% Write out the header
mRCImage = writeHeader(mRCImage);

% Write out the volume if it is not already on the disk
if mRCImage.flgVolume
  nElements = prod(size(mRCImage.volume));
  
  count = fwrite(mRCImage.fid, mRCImage.volume, getModeString(mRCImage));
  if count ~= nElements
    fprintf('Matrix contains %d but only wrote %d elements\n', ...
            nElements, count);
    error('Unsuccessful writing matrix');
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: save.m,v $
%  Revision 1.7  2005/05/09 18:44:40  rickg
%  Comment updates
%
%  Revision 1.6  2004/11/23 00:44:27  rickg
%  Delete a the file it exists and is specified by the filename
%
%  Revision 1.5  2004/09/18 00:01:34  rickg
%  Added comments
%
%  Revision 1.4  2004/07/20 23:14:50  rickg
%  Write out data type according to mode.
%
%  Revision 1.3  2004/07/14 22:54:06  rickg
%  Major strcutural change needs to be tested
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
