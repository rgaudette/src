%%
%%    Initialization
%%
LineWidth = 0.5;
Freq = [434.8 435.0 435.2 435.4];
clf

matFPower200 = zeros(4, 1651);
matFSigma0_200 = zeros(4, 1651);
matFPower240 = zeros(4, 1651);
matFSigma0_240 = zeros(4, 1651);

for nFile = 1:4,
    load(['MMtn' int2str(Freq(nFile)*10) '_200_240.mat']);

    %%
    %%    Create 200 degree matrix
    %%
    matFPower200(nFile, :) = v2p(matBeamformMF(:,2)).' / DirPath;
    matFSigma0_200(nFile, :) = matSigma0(:,2).';

    %%
    %%    Create 240 degree matrix
    %%
    matFPower240(nFile, :) = v2p(matBeamformMF(:,3)).' / DirPath;
    matFSigma0_240(nFile, :) = matSigma0(:,3).';    

end

%%
%%    Display mean power and sigma0
%%
hAxes = axes;
hLineVec = plot(dRange/1000, db(matFPower200.'));
set(hLineVec, 'LineWidth', LineWidth);
set(hLineVec(1), 'Color', 'r');
set(hLineVec(2), 'Color', 'g');
set(hLineVec(3), 'Color', 'c');
set(hLineVec(4), 'Color', 'm');
hold on
hMean = plot(dRange/1000, db(mean(matFPower200)));
set(hMean, 'LineWidth', 4 * LineWidth);
set(hMean, 'Color', 'w');

axis([0 200 -100 -50])
xlabel('Delta Range (kilomters)')
ylabel('Amplitude (dB)')
title('M Mountain Relative Power Level 13 uSec PCW Az=200')
grid


%%
%%    Create legend
%%
hold on
hLeg = plot([148 158], [-53 -53], 'r');
set(hLeg, 'LineWidth', LineWidth);
text(160, -53.25, '434.8 MHz')

hLeg = plot([148 158], [-56 -56], 'g');
set(hLeg, 'LineWidth', LineWidth);
text(160, -56.25, '435.0 MHz');

hLeg = plot([148 158], [-59 -59], 'c');
set(hLeg, 'LineWidth', LineWidth);
text(160, -59.25, '435.2 MHz');

hLeg = plot([148 158], [-62 -62], 'm');
set(hLeg, 'LineWidth', LineWidth);
text(160, -62.25, '435.4 MHz');

hLeg = plot([148 158], [-65 -65], 'w');
set(hLeg, 'LineWidth', 4 * LineWidth);
text(160, -65.25, 'Mean Power');
tag

keyboard

%%
%%    Power @ 240 Degrees
%%
clf
hAxes = axes;
hLineVec = plot(dRange/1000, db(matFPower240.'));
set(hLineVec, 'LineWidth', LineWidth);
set(hLineVec(1), 'Color', 'r');
set(hLineVec(2), 'Color', 'g');
set(hLineVec(3), 'Color', 'c');
set(hLineVec(4), 'Color', 'm');
hold on
hMean = plot(dRange/1000, db(mean(matFPower240)));
set(hMean, 'LineWidth', 4 * LineWidth);
set(hMean, 'Color', 'w');

axis([0 200 -100 -50])
xlabel('Delta Range (kilomters)')
ylabel('Amplitude (dB)')
title('M Mountain Relative Power Level 13 uSec PCW Az=240')
grid

%%
%%    Create legend
%%
hold on
hLeg = plot([148 158], [-53 -53], 'r');
set(hLeg, 'LineWidth', LineWidth);
text(160, -53.25, '434.8 MHz')

hLeg = plot([148 158], [-56 -56], 'g');
set(hLeg, 'LineWidth', LineWidth);
text(160, -56.25, '435.0 MHz');

hLeg = plot([148 158], [-59 -59], 'c');
set(hLeg, 'LineWidth', LineWidth);
text(160, -59.25, '435.2 MHz');

hLeg = plot([148 158], [-62 -62], 'm');
set(hLeg, 'LineWidth', LineWidth);
text(160, -62.25, '435.4 MHz');

hLeg = plot([148 158], [-65 -65], 'w');
set(hLeg, 'LineWidth', 4 * LineWidth);
text(160, -65.25, 'Mean Power');
tag

keyboard


%%
%%    Sigma0 @ 200 degrees.
%%
clf
hAxes = axes;
hLineVec = plot(matRange(:,2)/1000, db(matFSigma0_200.'));
set(hLineVec, 'LineWidth', LineWidth);
set(hLineVec(1), 'Color', 'r');
set(hLineVec(2), 'Color', 'g');
set(hLineVec(3), 'Color', 'c');
set(hLineVec(4), 'Color', 'm');
hold on
hMean = plot(matRange(:,2)/1000, db(mean(matFSigma0_200)));
set(hMean, 'LineWidth', 4 * LineWidth);
set(hMean, 'Color', 'w');

axis([0 200 -80 -20])
xlabel('Range (kilomters)')
ylabel('Amplitude (dB)')
title('M Mountain Sigma0  13 uSec PCW Az=200')
grid

%%
%%    Create legend
%%
hold on
hLeg = plot([148 158], [-23 -23], 'r');
set(hLeg, 'LineWidth', LineWidth);
text(160, -23.25, '434.8 MHz')

hLeg = plot([148 158], [-26 -26], 'g');
set(hLeg, 'LineWidth', LineWidth);
text(160, -26.25, '435.0 MHz');

hLeg = plot([148 158], [-29 -29], 'c');
set(hLeg, 'LineWidth', LineWidth);
text(160, -29.25, '435.2 MHz');

hLeg = plot([148 158], [-32 -32], 'm');
set(hLeg, 'LineWidth', LineWidth);
text(160, -32.25, '435.4 MHz');

hLeg = plot([148 158], [-35 -35], 'w');
set(hLeg, 'LineWidth', 4 * LineWidth);
text(160, -35.25, 'Mean Sigma0');
tag

keyboard


%%
%%    Sigma0 @ 240 degrees.
%%
clf
hAxes = axes;
hLineVec = plot(matRange(:,3)/1000, db(matFSigma0_240.'));
set(hLineVec, 'LineWidth', LineWidth);
set(hLineVec(1), 'Color', 'r');
set(hLineVec(2), 'Color', 'g');
set(hLineVec(3), 'Color', 'c');
set(hLineVec(4), 'Color', 'm');
hold on
hMean = plot(matRange(:,3)/1000, db(mean(matFSigma0_240)));
set(hMean, 'LineWidth', 4 * LineWidth);
set(hMean, 'Color', 'w');

axis([0 200 -80 -20])
xlabel('Range (kilomters)')
ylabel('Amplitude (dB)')
title('M Mountain Sigma0  13 uSec PCW Az=240')
grid

%%
%%    Create legend
%%
hold on
hLeg = plot([148 158], [-23 -23], 'r');
set(hLeg, 'LineWidth', LineWidth);
text(160, -23.25, '434.8 MHz')

hLeg = plot([148 158], [-26 -26], 'g');
set(hLeg, 'LineWidth', LineWidth);
text(160, -26.25, '435.0 MHz');

hLeg = plot([148 158], [-29 -29], 'c');
set(hLeg, 'LineWidth', LineWidth);
text(160, -29.25, '435.2 MHz');

hLeg = plot([148 158], [-32 -32], 'm');
set(hLeg, 'LineWidth', LineWidth);
text(160, -32.25, '435.4 MHz');

hLeg = plot([148 158], [-35 -35], 'w');
set(hLeg, 'LineWidth', 4 * LineWidth);
text(160, -35.25, 'Mean Sigma0');
tag

keyboard