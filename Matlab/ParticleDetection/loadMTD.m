%load in the mt contours and dynein points and create the dynein contours
ax6MTMod = ImodModel('ax6_MT2.mod');
mt1 = getPoints(ax6MTMod, 1, 1)';
mt2 = getPoints(ax6MTMod, 2, 1)';
% FIXME point 2 for ax3pts is right at the corner of points 4 and 5 of
% 'dynein34.mod'
mt3 = getPoints(ax6MTMod, 4, 1)';
mt4 = getPoints(ax6MTMod, 4, 1)';
mt5 = getPoints(ax6MTMod, 5, 1)';
mt6 = getPoints(ax6MTMod, 6, 1)';
mt7 = getPoints(ax6MTMod, 7, 1)';
mt8 = getPoints(ax6MTMod, 8, 1)';
mt9 = getPoints(ax6MTMod, 9, 1)';

ax6D1Mod = ImodModel('dynein12.mod');
ax6D1pts = getPoints(ax6D1Mod,1,1)';

ax6D2Mod = ImodModel('dynein23.mod');
ax6D2pts = getPoints(ax6D2Mod,1,1)';

ax6D3Mod = ImodModel('dynein34.mod');
ax6D3pts = getPoints(ax6D3Mod,1,1)';

ax6D4Mod = ImodModel('dynein45.mod');
ax6D4pts = getPoints(ax6D4Mod,1,1)';

ax6D5Mod = ImodModel('dynein56.mod');
ax6D5pts = getPoints(ax6D5Mod,1,1)';

ax6D6Mod = ImodModel('dynein67.mod');
ax6D6pts = getPoints(ax6D6Mod,1,1)';

ax6D7Mod = ImodModel('dynein78.mod');
ax6D7pts = getPoints(ax6D7Mod,1,1)';

ax6D8Mod = ImodModel('dynein89.mod');
ax6D8pts = getPoints(ax6D8Mod,1,1)';

ax6D9Mod = ImodModel('dynein91.mod');
ax6D9pts = getPoints(ax6D9Mod,1,1)';


dyneinContour1 = getDyneinContour(ax6D1pts, mt1);
%title('D1 shift')
%pause

dyneinContour2 = getDyneinContour(ax6D2pts, mt2);
%title('D2 shift')
%pause

dyneinContour3 = getDyneinContour(ax6D3pts, mt4);
%title('D3 shift')
%pause

dyneinContour4 = getDyneinContour(ax6D4pts, mt4);
%title('D4 shift')
%pause

dyneinContour5 = getDyneinContour(ax6D5pts, mt5);
%title('D5 shift')
%pause

dyneinContour6 = getDyneinContour(ax6D6pts, mt6);
%title('D6 shift')
%pause

dyneinContour7 = getDyneinContour(ax6D7pts, mt7);
%title('D7 shift')
%pause

dyneinContour8 = getDyneinContour(ax6D8pts, mt8);
%title('D8 shift')
%pause

dyneinContour9 = getDyneinContour(ax6D9pts, mt9);
%title('D9 shift')
