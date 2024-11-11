%xcorr3d        Calculate the 3-D cross-correlation function
%
%   [xcFunc] = xcorr3d(vol1, vol2, shape)
%
%   xcFunc      3D cross correlation function
%
%   vol1        The volume to be analyzed
%
%   vol2        The kernel to correlate throughout vol1
%
%   shape       OPTIONAL: The 'shape' of the cross correlation function to
%               compute.  This is the same argument as in convn
%     'full'   - returns the full N-D correlation
%     'same'   - returns the central part of the correlation that
%                is the same size as A.
%     'valid'  - (default) returns only the part of the result that can be
%                computed without assuming zero-padded arrays.  The
%                size of the result is max(size(A)-size(B)+1,0).

function [xcFunc] = xcorr3d(vol1, vol2, shape)

if nargin < 3
  shape = 'valid';
end

% reverse the smaller volume in all three domains because we are going to use
% convn to compute the correlation
kernel = flipdim(flipdim(flipdim(vol2, 1), 2), 3);

xcFunc = convn(vol1, kernel, shape);
