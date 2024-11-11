%getDimensions  Return the number of elements in each dimension
%
%   dim = getDimensions(mRCImage)
%
%   dim         The number of elements in each dimension
%               [nX nY nZ]
%
%   mRCImage    The MRCImage object to query the dimensions

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 17:47:04 $
%
%  $Revision: 1.4 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function dim = getDimensions(mRCImage)
dim = [mRCImage.header.nX mRCImage.header.nY mRCImage.header.nZ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: getDimensions.m,v $
%  Revision 1.4  2005/05/09 17:47:04  rickg
%  Comment updates
%
%  Revision 1.3  2004/09/17 04:34:41  rickg
%  Help typo fix
%
%  Revision 1.2  2004/09/08 23:13:38  rickg
%  Fixed help
%
%  Revision 1.1  2003/02/14 23:42:45  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%