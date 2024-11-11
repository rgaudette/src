%LTBGYOR        Light blue-green-yellow-orange-red colormap.
%
%   cmap = ltbgyor(n)
%
%   cmap        The 3 column (R G B) colormap.
%
%   n           [OPTIONAL] The number of entries in the colormap (default: 64).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:08 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: ltbgyor.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:08  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function cmap=ltbgyor(m)

if nargin < 1,
    m = 64;
end

% Make the LTBGYOR color map from MATLAB's hsv

cmtemp=hsv(round(m*16/9));
cmap=flipud(cmtemp(1:m,:));
