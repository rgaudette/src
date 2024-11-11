%writeEM         Write the file in EM format
%
%   writeEM(mRCImage, filename)
%
%   mRCImage    The MRCImage object.
%
%   filename    The name of the file to write.
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

function writeEM(mRCImage, filename)

fid = fopen(filename, 'w+');
if fid == -1
  disp(msg)
  error(['Unable to open ' filename ' w+']);
end
%
% Write the 512 byte EM header
%
count = fwrite(fid, [6 0 0], 'char');
if count ~= 3
  error(['Unable to write to : ' filename]);
end
switch  mRCImage.header.mode
 case 0
  count = fwrite(fid, 1, 'char');
 case 1
  count = fwrite(fid, 2, 'char');
 case 2
  count = fwrite(fid, 5, 'char');
 case 4
  count = fwrite(fid, 8, 'char');
 otherwise
  error(['Unimplemented mode in MRCImage: ' getModeString(mRCImage)]);
end
if count ~= 1
  error(['Unable to write to : ' filename]);
end

count = fwrite(fid, [mRCImage.header.nX mRCImage.header.nY mRCImage.header.nZ], 'int32');
if count ~= 3
  error(['Unable to write to : ' filename]);
end

%  Comment section
count = fwrite(fid, zeros(80,1), 'char');
if count ~= 80
  error(['Unable to write to : ' filename]);
end

% User defined section
count = fwrite(fid, zeros(40,1), 'int32');
if count ~= 40
  error(['Unable to write to : ' filename]);
end

% User data section
count = fwrite(fid, zeros(256,1), 'char');
if count ~= 256
  error(['Unable to write to : ' filename]);
end


% Write out the data now with X dimension as the fastest, then Y, then Z
nElem = mRCImage.header.nX * mRCImage.header.nY;
modeString = getModeString(mRCImage);
for iZ = 1:mRCImage.header.nZ
  count = fwrite(fid, getImage(mRCImage, iZ), modeString);
  if count ~= nElem
    error(['problem writing data to : ' filename]);
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: writeEM.m,v $
%  Revision 1.2  2005/05/09 18:44:40  rickg
%  Comment updates
%
%  Revision 1.1  2004/07/20 23:15:36  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
