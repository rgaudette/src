%doFwdCalc      Calculate the forward system matrix from the slab image parms.
%
%   This script extracts the current system parameters from the GUI Slab
%   image interface and calculates the forward matrix specified by the
%   parameters as well as the incident detector fluence.
%
%   Calls: getall, dpdwfdda, dpdwfddazb, 
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
%  $Log: doFwdCalc.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:41  rickg
%  Matlab Source
%
%  Revision 2.1  1998/08/20 16:23:24  rjg
%  Moved resetting of SVD flags to genfwdmat.
%
%  Revision 2.0  1998/08/05 16:38:08  rjg
%  Most functionality moved into the function genfwdmat so that the
%  data structure can be filled in and clean up of temporary variables is
%  handled by the function cleanup.
%
%  Revision 1.7  1998/07/30 19:44:04  rjg
%  Changed boundary condition to switch on string values instead of codes.
%
%  Revision 1.6  1998/06/10 18:19:19  rjg
%  Fixed modulation frequency bug.  Previous version passed frequency in
%  Hz instead of MHz
%  Added correct handling of incident field for multiple frequencies.
%  Removed temporary forward matrix and incident vector
%
%  Revision 1.5  1998/06/05 17:43:39  rjg
%  Fixed bug where diffuse source depth was calculated as 10 diffusion
%  lengths instead of 1!!!
%  Added print out of diffuse source depth.
%
%  Revision 1.4  1998/06/04 15:37:26  rjg
%  Restructured incident fluence for non-zero frequencies by stacking real
%  over imaginary parts.
%
%  Revision 1.3  1998/06/03 16:18:09  rjg
%  Added parameter reporting code.
%  Add flags for econ/normal SVD requirement, removed single flag.
%
%  Revision 1.2  1998/04/29 15:12:38  rjg
%  Added busy light.
%
%  Revision 1.1  1998/04/28 20:15:17  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%  Set the busy light to red
%%
UIHandles = get(gcf, 'UserData');
set(UIHandles.hLight, 'Color', [1 0 0]);
drawnow;

%%
%%  Get all of the measurement parameters from GUI
%%
if exist('ds', 'var')
    ds = getFwdModelInfo(ds);
else
    ds = getFwdModelInfo;
end

%%
%%  Calculate the forward matrix and incident fields returning all
%%  results in data structure.
%%
ds.Fwd = genFwdMat(ds.Fwd, ds.Debug);

set(UIHandles.hLight, 'Color', [0 1 0]);
drawnow;
clear UIHandles;