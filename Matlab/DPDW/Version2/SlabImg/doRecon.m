%doRecon        Calculate the reconstruction data from the slab image parms.
%
%   This script extracts the current system parameters from the GUI Slab
%   image interface and reconstructs a set of images based from the measured
%   data and the forward matrix.
%
%   Calls: art, sirt, fatmn, fattsvd, fatmtsvd
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: doRecon.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:14  rickg
%  Matlab Source
%
%  Revision 2.2  1999/02/05 20:29:23  rjg
%  Moved code into genrecon.m
%
%  Revision 2.1  1998/08/12 19:36:47  rjg
%  Added missing data structure reference for null-space component.
%  Remove extraneous error reporting.
%
%  Revision 2.0  1998/08/10 21:40:00  rjg
%  Added the ability to handle mutlple wavelengths.
%  Updated structure references to be consistent with V2.
%
%  Revision 1.5  1998/06/11 17:56:04  rjg
%  Fixed bug where the null space contribution in the MTSVD was recomputed
%  when only lambda had changed but the null space size had changed in a
%  previous iteration.  Basically forgot to reset the prev null space size.
%
%  Revision 1.4  1998/06/10 18:26:05  rjg
%  Changed bn to Phi_ScatN for compatibility with doMeasData.
%  Fixed bug regarding reseting flag for economy SVD.
%
%  Revision 1.3  1998/06/03 16:33:37  rjg
%  Uses SIdefines codes
%  Added MTSVD operations
%
%  Revision 1.2  1998/04/29 15:13:24  rjg
%  Added busy light
%
%  Revision 1.1  1998/04/28 20:20:04  rjg
%  Initial revision
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

UIHandles = get(gcf, 'UserData');
set(UIHandles.hLight, 'Color', [1 0 0]);
drawnow;

ds = getrecinfo(ds);

%%
%%  Compute selected reconstruction
%%
ds = genrecon(ds);

set(UIHandles.hLight, 'Color', [0 1 0]);
drawnow;
