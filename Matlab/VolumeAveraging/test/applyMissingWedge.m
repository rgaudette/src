%applyMissingWedge Apply a missing wedge to a volume
%
%   vol = applyMissingWedge(vol, tiltRange)
%
%   vol         The input and output volumes (space domain)
%
%   tiltRange   The tilt range to simulate on the data (degrees)
%
%
%   applyMissingWedge zeros out the missing wedge in the frequency domain
%   of the data volume.  Each X-Z plane 
%
%   Calls: none
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/10/25 17:24:06 $
%
%  $Revision: 1.1 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function vol = applyMissingWedge(vol, tiltRange)

szVol = size(vol);
mask = wedgeMask(tiltRange, [szVol(1) 1 szVol(3)]);
% Iterate over each Y slice applying
for iSlice = 1:szVol(2)
  V = fftshift(fftn(vol(:, iSlice, :))) .* mask;
  vol(:, iSlice, :) = ifftn(ifftshift(V));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: applyMissingWedge.m,v $
%  Revision 1.1  2005/10/25 17:24:06  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
