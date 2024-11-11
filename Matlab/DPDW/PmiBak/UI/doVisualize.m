%doVisualize    Display the selected visualization technique.
%
%   Calls: bgyor, mcontour, mslice.
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
%  $Log: doVisualize.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:41  rickg
%  Matlab Source
%
%  Revision 2.2  1999/02/05 20:33:17  rjg
%  Switched color colrmap to jet.
%
%  Revision 2.1  1998/09/09 15:07:09  rjg
%  Added slice domain handling for mcontour.
%
%  Revision 2.0  1998/08/10 21:41:26  rjg
%  Added the ability to display multiple wavelengths.
%  Updated the structure references to be consistent with V2.
%
%  Revision 1.4  1998/07/30 19:53:17  rjg
%  Change SIdefines codes to strings.
%
%  Revision 1.3  1998/06/10 18:27:09  rjg
%  Flipped grey colormap so that dark indicates a large value, better for
%  printing hardcopys.
%  Added silabel.
%
%  Revision 1.2  1998/06/03 16:35:11  rjg
%  Uses SIdefines codes
%  Figure is now created with default position/size
%
%  Revision 1.1  1998/04/29 15:14:07  rjg
%  Initial revision
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hControl = gcf;
UIHandles = get(hControl, 'UserData');
set(UIHandles.hLight, 'Color', [1 0 0]);
drawnow;

ds = getVisInfo(ds);
UIHandles.CurrFigure = showImage(ds, UIHandles.CurrFigure);
set(hControl, 'UserData', UIHandles);

set(UIHandles.hLight, 'Color', [0 1 0]);
drawnow;
clear UIHandles;