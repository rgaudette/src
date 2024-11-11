%doMeasData     Calculate the measured data from the slab image parms.
%
%   This script extracts the current system parameters from the GUI Slab
%   image interface and calculates the measured data (detector responses).
%
%   Calls: getmdinfo, genmeasdata
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:14 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: doMeasData.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:14  rickg
%  Matlab Source
%
%  Revision 2.7  1998/12/23 16:41:23  rjg
%  Fixed help comments.
%
%  Revision 2.6  1998/08/20 18:57:23  rjg
%  Moved all processing operations into a single function so that batch
%  processing is possible.
%
%  Revision 2.5  1998/08/12 19:34:38  rjg
%  Fixed handling of detector side noise for multi-wavelength cases.
%
%  Revision 2.4  1998/08/07 19:29:58  rjg
%  No code changes, fixed log field.
%
%  Revision 1.2  1998/04/29 15:13:04  rjg
%  Added busy light.
%
%  Revision 1.1  1998/04/28 20:17:51  rjg
%  Initial revision
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

UIHandles = get(gcf, 'UserData');
set(UIHandles.hLight, 'Color', [1 0 0]);
drawnow;

ds = getmdinfo(ds);

%%
%%  Generate the measured data.
%%
ds = genmeasdata(ds);

fprintf('Max Incident-to-Purturbation-Ratio: %f dB\n', ...
    20*log10(max(ds.IPR)));
fprintf('Min Incident-to-Purturbation-Ratio: %f dB\n', ...
    20*log10(min(ds.IPR)));

set(UIHandles.hLight, 'Color', [0 1 0]);
drawnow;
