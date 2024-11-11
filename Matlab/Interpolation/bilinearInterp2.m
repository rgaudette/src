%bilinearInterp2    2D bilinear interpolation
%
%   zi = bilinearInterp2(z, xi, yi)
%
%   zi          The interpolated 2D sample array
%
%   z           The original 2D sample array
%
%   xi, yi      The sample values to be interpolated
%
%
%   Interpolate a 2D sample array.  The original 2D sample array is assumed
%   to be sampled on uniform grid at sample locations [0:nX-1] and [0:nY-1].
%
%   Calls: none.
%
%   See also: none
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/21 00:32:45 $
%
%  $Revision: 1.1 $
%
%  $Log: bilinearInterp2.m,v $
%  Revision 1.1  2004/01/21 00:32:45  rickg
%  Initial revision
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function zi = bilinearInterp2(z, xi, yi)

%  Indexes are shifted by 1 because the data is assumed to sampled on a
%  [0:nX-1], [0:nY-1] grid and MATLAB indexes [1:nX], [1:nY].

% Interpolate along the required rows
lowerX = floor(xi);
distLowerX = xi - lowerX;
distUpperX = 1 - distLowerX;
lowerY = floor(yi);
idxLowerX = sub2ind(size(z), lowerY+1, lowerX+1);
idxUpperX = sub2ind(size(z), lowerY+1, lowerX+2);
interpLowerY = z(idxLowerX) .* distUpperX + z(idxUpperX) .* distLowerX;

idxLowerX = sub2ind(size(z), lowerY+2, lowerX+1);
idxUpperX = sub2ind(size(z), lowerY+2, lowerX+2);
interpUpperY = z(idxLowerX) .* distUpperX + z(idxUpperX) .* distLowerX;

% Interpolate down the columns of interpolants
distLowY = yi - lowerY;
distUpperY = 1 - distLowY;
zi = interpLowerY .* distUpperY + interpUpperY .* distLowY;
