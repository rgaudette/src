
function resurfseq(fX, fY, fZ)

idxStart = 132;
idxStep = 2;
nRows = 16;
nCols = 16;

hAx1 = subplot(2,3,1);

idxSample = idxStart;
XData = reshape(fX(:, idxSample), nRows, nCols);
YData = reshape(fY(:, idxSample), nRows, nCols);
ZData = reshape(fZ(:, idxSample), nRows, nCols);
Mag = sqrt(XData.^2 + YData.^2 + ZData.^2);
c1 = contour(Mag, [-100:10:100]);
set(hAx1, 'YDir', 'reverse');
grid
axis('square')
xlabel('Column Index')
ylabel('Row Index')
title(['Time: ' int2str(idxSample) ' mS']);
drawnow;



hAx2 = subplot(2,3,2);

idxSample = idxStart + idxStep;
XData = reshape(fX(:, idxSample), nRows, nCols);
YData = reshape(fY(:, idxSample), nRows, nCols);
ZData = reshape(fZ(:, idxSample), nRows, nCols);
Mag = sqrt(XData.^2 + YData.^2 + ZData.^2);
c1 = contour(Mag, [-100:10:100]);
set(hAx2, 'YDir', 'reverse');
grid
axis('square')
xlabel('Column Index')
ylabel('Row Index')
title(['Time: ' int2str(idxSample) ' mS']);
drawnow;

hAx3 = subplot(2,3,3);

idxSample = idxStart + 2*idxStep;
XData = reshape(fX(:, idxSample), nRows, nCols);
YData = reshape(fY(:, idxSample), nRows, nCols);
ZData = reshape(fZ(:, idxSample), nRows, nCols);
Mag = sqrt(XData.^2 + YData.^2 + ZData.^2);
c1 = contour(Mag, [-100:10:100]);
set(hAx3, 'YDir', 'reverse');
grid
axis('square')
xlabel('Column Index')
ylabel('Row Index')
title(['Time: ' int2str(idxSample) ' mS']);
drawnow;

hAx4 = subplot(2,3,4);

idxSample = idxStart + 3*idxStep;
XData = reshape(fX(:, idxSample), nRows, nCols);
YData = reshape(fY(:, idxSample), nRows, nCols);
ZData = reshape(fZ(:, idxSample), nRows, nCols);
Mag = sqrt(XData.^2 + YData.^2 + ZData.^2);
c1 = contour(Mag, [-100:10:100]);
set(hAx4, 'YDir', 'reverse');
grid
axis('square')
xlabel('Column Index')
ylabel('Row Index')
title(['Time: ' int2str(idxSample) ' mS']);
drawnow;


hAx5 = subplot(2,3,5);

idxSample = idxStart + 4*idxStep;
XData = reshape(fX(:, idxSample), nRows, nCols);
YData = reshape(fY(:, idxSample), nRows, nCols);
ZData = reshape(fZ(:, idxSample), nRows, nCols);
Mag = sqrt(XData.^2 + YData.^2 + ZData.^2);
c1 = contour(Mag, [-100:10:100]);
set(hAx5, 'YDir', 'reverse');
grid
axis('square')
xlabel('Column Index')
ylabel('Row Index')
title(['Time: ' int2str(idxSample) ' mS']);
drawnow;

hAx6 = subplot(2,3,6);

idxSample = idxStart + 5*idxStep;
XData = reshape(fX(:, idxSample), nRows, nCols);
YData = reshape(fY(:, idxSample), nRows, nCols);
ZData = reshape(fZ(:, idxSample), nRows, nCols);
Mag = sqrt(XData.^2 + YData.^2 + ZData.^2);
c1 = contour(Mag, [-100:10:100]);
set(hAx6, 'YDir', 'reverse');
grid
axis('square')
xlabel('Column Index')
ylabel('Row Index')
title(['Time: ' int2str(idxSample) ' mS']);
drawnow;
