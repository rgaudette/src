%doNoise        Add noise to the scattered field measurements.
%
%   This script extracts the current noise parameters from the GUI Slab
%   image interface and calculates the noise vectors ading them to the
%   noisy scattered field data.
%
%   Calls: 
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
%  $Log: doNoise.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:41  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

UIHandles = get(gcf, 'UserData');
set(UIHandles.hLight, 'Color', [1 0 0]);
drawnow;

ds = getNoiseInfo(ds);

ds = genNoise(ds);

set(UIHandles.hLight, 'Color', [0 1 0]);
drawnow;
clear UIHandles;