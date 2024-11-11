%cntShow        Show a inverted, smoothed, countour slice view of a volume

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/09 17:30:29 $
%
%  $Revision: 1.2 $
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function cntShow(volume)
clf
set(gcf, 'Renderer', 'OpenGL')
% invert the volume since we are negatively stained
volInv = double(max(volume(:))) - double(volume);

% smooth the volume
volInvSm = smooth3(volInv);

cntVol = volInvSm;

maxVal = max(cntVol(:))
nX = size(cntVol,1);
nY = size(cntVol,1);
nZ = size(cntVol,1);


%subplot(2,1,1)
contourslice(cntVol, [1:nX], [1:nY], [], 0.75*[maxVal maxVal]);
grid on
view([45 45])

xlabel('X Axis');
ylabel('Y Axis');
zlabel('Z Axis');

%
%subplot(2,1,2)
%contourslice(cntVol, [], [1:9], [], [maxVal*0.5 maxVal*0.75]);
%grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: cntShow.m,v $
%  Revision 1.2  2005/05/09 17:30:29  rickg
%  Comment updates
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%