%open           Open a MRCImage file
%
%   mRCImage = open(mRCImage, filename, flgLoadVolume, debug)
%
%   mRCImage    The opened MRCImage object
%
%   filename    The file name of the MRCImage file to load
%
%   flgLoadVolume OPTIONAL: Load in the volume data (default: 1)
%
%   debug       OPTIONAL: Print out information as the header is loaded.
%
%
%   open loads the MRCImage header of the specified file and allows
%   the MRCImage object to be manipulated. 
%
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 18:44:40 $
%
%  $Revision: 1.12 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mRCImage = open(mRCImage, filename, flgLoadVolume, debug)

if nargin < 4
  debug = 0;
  if nargin < 3
    flgLoadVolume = 1;
  end
end

% Check to see a the file is already open
if ~ isempty(mRCImage.fid)
  error(...
    'A MRC file is already open, close it before trying to reuse this object');
  return
end
% Open the file read-only, save the fid for future access and the filename
% if we need to reopen it r+ 
[fid msg]= fopen(filename, 'r');
if fid ~= -1
  mRCImage.fid = fid;
  if filename(1) == '/'
    mRCImage.filename = filename;
  else
    mRCImage.filename = [pwd '/' filename];
  end
  [mRCImage] = readHeader(mRCImage, debug);
  
  if flgLoadVolume
    %  Read in the volume in it's native format
    nElements = mRCImage.header.nX * mRCImage.header.nY * mRCImage.header.nZ;
    precision = [getModeString(mRCImage) '=>' getModeString(mRCImage)];
    [mRCImage.volume count] = fread(mRCImage.fid, nElements,  precision);
    if count ~= nElements
      error(['Expected ' int2str(nElements) ' elements, read ' int2str(count)]);
    end
    mRCImage.volume = reshape(mRCImage.volume, ...
                              mRCImage.header.nX, ...
                              mRCImage.header.nY, ...
                              mRCImage.header.nZ);
    mRCImage.flgVolume = 1;
    fclose(mRCImage.fid);
    mRCImage.fid = [];
  end
else
  error('Unable to open file: %s.\nReason: %s', filename, msg);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: open.m,v $
%  Revision 1.12  2005/05/09 18:44:40  rickg
%  Comment updates
%
%  Revision 1.11  2005/01/29 00:33:24  rickg
%  Better error reporting
%
%  Revision 1.10  2004/03/08 23:22:38  rickg
%  Removed debugging output
%
%  Revision 1.9  2004/03/08 23:20:44  rickg
%  Added full pathname so that the file can be reopened.
%
%  Revision 1.8  2004/01/20 21:12:34  rickg
%  Removed devel message
%
%  Revision 1.7  2003/11/17 06:14:25  rickg
%  Added functionality to not load volume
%
%  Revision 1.6  2003/11/14 06:44:09  rickg
%  Loading data volume is now optional
%
%  Revision 1.5  2003/06/17 14:12:50  rickg
%  Fixed error message
%
%  Revision 1.4  2003/04/09 04:31:10  rickg
%  Automatically read in volume data leave in original format
%
%  Revision 1.3  2003/01/02 18:23:51  rickg
%  Help section update
%
%  Revision 1.2  2002/12/27 15:03:29  rickg
%  Added debug flag
%
%  Revision 1.1.1.1  2002/12/14 07:28:50  rickg
%  Initial Revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
