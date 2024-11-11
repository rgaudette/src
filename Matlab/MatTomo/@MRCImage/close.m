%close          Close the mRCImage file and all resources
%
%   mRCImage = close(mRCImage)
%
%   mRCImage    The MRCImage object to have its file closed
%
%
%   This function closes the file pointer associated with the object.
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
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mRCImage = close(mRCImage)

if ~ isempty(mRCImage.fid)
  try 
    fclose(mRCImage.fid);
  catch
    mRCImage.fid = [];
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: close.m,v $
%  Revision 1.7  2005/05/09 17:47:04  rickg
%  Comment updates
%
%  Revision 1.6  2004/10/01 23:36:29  rickg
%  Removed warning about file already being closed
%
%  Revision 1.5  2004/03/20 00:22:59  rickg
%  Empty the FID if the file is already closed
%
%  Revision 1.4  2003/11/17 06:13:43  rickg
%  Help text completion
%
%  Revision 1.3  2003/02/14 23:42:16  rickg
%  Help text fix
%
%  Revision 1.2  2003/01/09 00:06:39  rickg
%  Fixed variable name error and removed copy statement, not necessary
%
%  Revision 1.1.1.1  2002/12/14 07:28:50  rickg
%  Initial Revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
