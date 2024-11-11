%BGYOR          Blue-green-yellow-orange-red colormap.
%
%   cmap = bgyor(n)
%
%   cmap        The 3 column (R G B) colormap.
%
%   n           [OPTIONAL] The number of entries in the colormap (default: 64).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:05 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: bgyor.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:05  rickg
%  Matlab Source
%
%  Revision 1.1  1998/04/15 22:46:00  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function cmap=bgyor(m)

if nargin < 1,
    m = 64;
end

% Make the VIBGYOR color map from MATLAB's hsv

cmtemp=hsv(round(m*16/11));
cmap=flipud(cmtemp(1:m,:));
