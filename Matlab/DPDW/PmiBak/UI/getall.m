%GETALL         Return all of the system parameter from the Slab Image GUI.
%
%   stSlabImg = getall;
%
%   stSlabImg   The structure containing all of the Slab Image parameters.
%
%
%   GETALL queries each known edit or radio button control to fill in the
%   all of the members of the data structure.  The GUI must be the current
%   figure.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:41 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: getall.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:41  rickg
%  Matlab Source
%
%  Revision 2.1  1998/08/20 20:28:55  rjg
%  Preserves any computed data if the slab image data structure is passed on the
%  command line.
%
%  Revision 2.0  1998/08/05 16:36:48  rjg
%  Broke up into seperate functions for handling of V2.0 data
%  structure.
%
%  Revision 1.6  1998/07/30 19:58:35  rjg
%  Removed SIdefines codes, uses string now.
%  Added parameters for the three noise models
%  Added parameters for TCG
%
%  Revision 1.5  1998/06/03 16:39:02  rjg
%  Uses SIdefines codes
%  MTSVD parameters
%
%  Revision 1.4  1998/04/29 16:10:32  rjg
%  Fixed else statment reporting ans, changed to elseif.
%  
%  Added comments.
%
%  Revision 1.3  1998/04/29 15:15:28  rjg
%  Added visualization techniques members.
%
%  Revision 1.2  1998/04/28 20:26:12  rjg
%  Added to help.
%
%  Revision 1.1  1998/04/28 20:24:42  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ds = getall(ds)

if nargin < 1
    ds = [];
end
ds.Version = 3;
ds = getFwdModelInfo(ds);
ds = getInvModelInfo(ds);
ds = getObjectInfo(ds);
ds = getNoiseInfo(ds);
ds = getRecInfo(ds);
ds = getVisInfo(ds);