function clipline(handle)
% Example of how manually clip lines to the axes in MATLAB.
%
% Note: If the line does not intersect the axes at a point 
%       defined in the X, Y, or Z data, then the line is
%       not clipped at the axes.  It is clipped relative to
%       the data.
%
%       To properly clipthe line relative to the data, you
%       have to use interpolation.  This was not included in the
%       example.
%
% DISCLAIMER:  This M-file was developed for my own personal use.
%              It has not been tested, nor is it supported by The
%              MathWorks, Inc.  Please feel free to use and modify
%              this program to suit your needs.

% Written by John L. Galenski III - Aug. 31, 1995
% Copyright(c) By The MathWorks, Inc, 1995
% All Rights reserved
% LDM083195jlg

% Get axis limits
ax = axis;
axis(ax) % Freeze limits so they do not change when 
         %printed/resized

% Clip the line
for i = 1:length(handle)
  h = handle(i);
  Xd = get(h,'XData');
  Yd = get(h,'YData');
  Zd = get(h,'ZData');
  
  % Test range
  Xm = (Xd<ax(1) | Xd>ax(2));
  Xd(Xm) = nan * ones(1,sum(Xm));
  Ym = (Yd<ax(3) | Yd>ax(4));
  Yd(Ym) = nan * ones(1,sum(Ym));
  if length(ax)==6
    Zm = (Zd<ax(5) | Zd>ax(6));
    Zd(Zm) = nan * ones(1,sum(Zm));
  end
  
  % Update plot
  set(h,'XData',Xd,'YData',Yd)
  if ~isempty(Zd)
    set(h,'ZData',Zd)
  end
end