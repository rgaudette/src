%getModeString  Return the correct string for the specified mode (data type)
%
%   modeString = getModeString(mRCImage)
%
%   modeString  A string describing the data type stored on the MRCIMage:
%               'uint8', 'int16', 'float32'
%
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 17:47:04 $
%
%  $Revision: 1.4 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function modeString = getModeString(mRCImage)

switch  mRCImage.header.mode
 case 0
  modeString = 'uint8';
 case 1
  modeString = 'int16';
 case 2
  modeString = 'float32';
 case 3
  modeString = 'unknown';
 case 4
  modeString = 'unknown';
 otherwise
  modeString = 'unknown';
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: getModeString.m,v $
%  Revision 1.4  2005/05/09 17:47:04  rickg
%  Comment updates
%
%  Revision 1.3  2005/03/02 22:39:10  rickg
%  Help comment update
%
%  Revision 1.2  2003/06/13 22:04:20  rickg
%  Changed mode string to uint8
%
%  Revision 1.1  2003/02/14 23:52:44  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
