%VIBGYOR
%-----------------------------------------------------------------
%          VIBGYOR.M
%-----------------------------------------------------------------
% This function returns an M x 3 color matrix containing a
% VIBGYOR colormap. (The full spectrum, with violet being low/cold
%                                and red being high/hot!)
%-----------------------------------------------------------------
% Usage: cmap=vibgyor(m)
%
%-----------------------------------------------------------------

function cmap=vibgyor(m)

if nargin < 1,
    m = 64;
end

% Make the VIBGYOR color map from MATLAB's hsv

cmtemp=hsv(m*9/8);
cmap=flipud(cmtemp(1:m,:));
