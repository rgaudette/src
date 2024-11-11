
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:35 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: dualcell.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:35  rickg
%  Matlab Source
%
%  
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


PulseWidth_1 = 13e-6;
PulseWidth_2 = 5e-6;
BeamWidth_1 = 6;
BeamWidth_2 = 9;

C = 299792458;
TxPos = -57.33+j*34.04;

XDist = [-65:.2:10];
YDist = [-60:.2:60]';
mPos = ones(length(YDist),1) * XDist + j * YDist * ones(1,length(XDist));
mTxRelPos = mPos - TxPos;

Rd = abs(TxPos) * 1000;
R1 = abs(mTxRelPos) * 1000;
R2 = abs(mPos) * 1000;
mDelta = R1 + R2 - Rd;
maxPos = max(max(R1));

mDCell_1 = fix(mDelta / C / PulseWidth_1);
mDCell_2 = fix(mDelta / C / PulseWidth_2);

%%
%%    Plotting area for first cell map.
%% 
clf
axes('position', [.15 .2 .33 .6])
set(gca, 'Box', 'on')
cs1 = contour(XDist, YDist, mDCell_1, [0:30], 'r');
hold on
for angle = [0:BeamWidth_1:360],
    px = maxPos * cos(angle * pi / 180);
    py = maxPos * sin(angle * pi / 180);
    plot([0 px], [0 py], '-b');
end
plot(0,0, 'x')
plot(TxPos, 'x')

hold off

set(gca, 'FontWeight', 'bold')

xlabel('KILOMETERS')
hXL1 = get(gca, 'xlabel');
set(hXL1, 'FontSize', 14);
set(hXL1, 'FontWeight', 'bold');

ylabel('KILOMETERS')
hYL1 = get(gca, 'ylabel');
set(hYL1, 'FontSize', 14);
set(hYL1, 'FontWeight', 'bold');

title('77 KHz Bandwidth')
hT1 = get(gca, 'title');
set(hT1, 'FontSize', 16);
set(hT1, 'FontWeight', 'bold');

%%
%%    Plotting area for 2nd map.
%% 
axes('position', [.52 .2 .33 .6])
set(gca, 'Box', 'on')
cs2 = contour(XDist, YDist, mDCell_2, [0:75], 'r');
hold on
for angle = [0:BeamWidth_2:360],
    px = maxPos * cos(angle * pi / 180);
    py = maxPos * sin(angle * pi / 180);
    plot([0 px], [0 py], '-b');
end
plot(0,0, 'x')
plot(TxPos, 'x')
hold off
set(gca, 'FontWeight', 'bold')

xlabel('KILOMETERS')
hXL2 = get(gca, 'xlabel');
set(hXL2, 'FontSize', 14);
set(hXL2, 'FontWeight', 'bold');

title('200 KHz Bandwidth')
hT2 = get(gca, 'title');
set(hT2, 'FontSize', 16);
set(hT2, 'FontWeight', 'bold');
