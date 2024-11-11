%%
%%    Initialization
%%
clf
strTitle = ['MMtn  ' num2str(Freq) ' MHz'];
strWfm = '13 uSec PCW';
LineWidth = 1;

%%
%%    Find indicies of azimuth of interest.
%%
idxAzimuth = find((Azimuth(1,:) > (PlotAz - 2.5)) & ...
             (Azimuth(1,:) < (PlotAz + 2.5)));

%%
%%    Plot all of the matched filter output powers
%%    (relative to the direct path).
%%
hAxes = axes;
hLineVec = plot(dRange/1000, db(v2p(matBeamformMF(:,idxAzimuth))/DirPath));
set(hLineVec, 'LineWidth', LineWidth);
set(hLineVec(1), 'Color', 'r');
set(hLineVec(2), 'Color', 'g');
set(hLineVec(3), 'Color', 'c');
axis([0 200 -100 -50])
xlabel('Delta Range (kilomters)')
ylabel('Amplitude (dB)')
title(['Temporal Stability, Power Relative to Direct Path: ' ...
    strTitle '  ' strWfm '  ' num2str(PlotAz) ' Deg.']);
grid

%%
%%    Create legend
%%
hold on
hLeg = plot([148 158], [-53 -53], 'r');
set(hLeg, 'LineWidth', LineWidth);
text(160, -53.25, 'T = 0');
hLeg = plot([148 158], [-56 -56], 'g');
set(hLeg, 'LineWidth', LineWidth);
text(160, -56.25, ['T = ' num2str(etime(matCPITime(idxAzimuth(2),:), ...
    matCPITime(idxAzimuth(1),:)) / 60) ' mins']);

hLeg = plot([148 158], [-59 -59], 'c');
set(hLeg, 'LineWidth', LineWidth);
text(160, -59.25, ['T = ' num2str(etime(matCPITime(idxAzimuth(3),:), ...
    matCPITime(idxAzimuth(1),:)) / 60) ' mins']);

tag