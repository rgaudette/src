%SCALE_EX       Mallat decomposition detail sequence plot
%
%   scale_ex(Lead)
%
%   Lead    The sequence to decompose and dispay

function scale_ex(Lead)

%%
%%  Initializations
%%
Lead = Lead(:);
nSamps = length(Lead);

clf
set(gcf, 'Units', 'normalized');
orient landscape

%%
%%  Draw single lead plot at top
%%
ZoomMin = 250;
ZoomMax = 400;
hLeadAx = axes('position', [0.25 0.77 0.2 0.15]);
h = plot(Lead, 'r');
set(h, 'LineWidth', 1.0);
axis([0 nSamps -50 25])
xlabel('Time (mS)');
ylabel('Amplitude (mV)');
grid
hold on
h = plot([ZoomMin ZoomMin ZoomMax ZoomMax ZoomMin], [0 20 20 0 0], 'g');
set(h, 'LineWidth', 1.0);

%%
%%  Draw close up of recovery region
%%
hRecov = axes('position', [0.55 0.77 0.2 0.15]);
h = plot([ZoomMin:ZoomMax], Lead(ZoomMin:ZoomMax), 'r');
set(h, 'LineWidth', 1.0);
axis([ZoomMin ZoomMax -0 20]);
xlabel('Time (mS)');
ylabel('Amplitude (mV)');
grid


%%
%%  Get region esitmates from trecov3
%%
Decomp = mallat(Lead, 5);
Decomp(:,1:5) = Decomp(:,1:5);
[idxRecov Peaks Regions] = trecov3(Lead');

%%
%%  1st scale
%%
Space = 0.08;
Xwidth = 0.24;
Ywidth = 0.25;
hScale1 = axes('position', [Space 2*Space+Ywidth Xwidth Ywidth]);
h = plot(ZoomMin:ZoomMax, Decomp(ZoomMin:ZoomMax,1), 'r');
set(h, 'LineWidth', 1.0);
axis([ZoomMin ZoomMax -5 10]);
grid
ylabel('Ampltitude');
title('Detail:1')


hScale2 = axes('position', [2*Space+Xwidth 2*Space+Ywidth Xwidth Ywidth]);
h = plot(ZoomMin:ZoomMax, Decomp(ZoomMin:ZoomMax,2), 'r');
set(h, 'LineWidth', 1.0);
hold on
hp = plot(Peaks(2), Decomp(Peaks(2), 2), 'og');
set(hp, 'LineWidth', 2)
h = plot(Regions(1,2) * [1 1], [-10 10], 'b');
set(h, 'LineWidth', 1.0);
h = plot(Regions(2,2) * [1 1], [-10 10], 'b');
set(h, 'LineWidth', 1.0);
axis([ZoomMin ZoomMax -10 10]);
grid
title('Detail:2')


hScale3 = axes('position', [3*Space+2*Xwidth 2*Space+Ywidth Xwidth Ywidth]);
h = plot(ZoomMin:ZoomMax, Decomp(ZoomMin:ZoomMax,3),'r');
set(h, 'LineWidth', 1.0);
hold on
hp = plot(Peaks(3), Decomp(Peaks(3), 3), 'og');
set(hp, 'LineWidth', 2)
h = plot(Regions(1,3) * [1 1], [-10 10], 'b');
set(h, 'LineWidth', 1.0);
h = plot(Regions(2,3) * [1 1], [-10 10], 'b');
set(h, 'LineWidth', 1.0);
axis([ZoomMin ZoomMax -10 10]);
grid
title('Detail:3')



hScale4 = axes('position', [Space Space Xwidth Ywidth]);
h = plot(ZoomMin:ZoomMax, Decomp(ZoomMin:ZoomMax,4), 'r');
set(h, 'LineWidth', 1.0);
hold on
hp = plot(Peaks(4), Decomp(Peaks(4), 4), 'og');
set(hp, 'LineWidth', 2)
h = plot(Regions(1,4) * [1 1], [-10 10], 'b');
set(h, 'LineWidth', 1.0);
h = plot(Regions(2,4) * [1 1], [-10 10], 'b');
set(h, 'LineWidth', 1.0);

axis([ZoomMin ZoomMax -10 10]);
grid
xlabel('Time (mS)')
ylabel('Ampltitude');
title('Detail:4')


hScale5 = axes('position', [2*Space+Xwidth Space Xwidth Ywidth]);
h = plot(ZoomMin:ZoomMax, Decomp(ZoomMin:ZoomMax,5), 'r');
set(h, 'LineWidth', 1.0);
hold on
hp = plot(Peaks(5), Decomp(Peaks(5), 5), 'og');
set(hp, 'LineWidth', 2)
axis([ZoomMin ZoomMax -10 10]);
grid
xlabel('Time (mS)')
title('Detail:5')


hScale6 = axes('position', [3*Space+2*Xwidth Space Xwidth Ywidth]);
h = plot(ZoomMin:ZoomMax, Decomp(ZoomMin:ZoomMax,6), 'r');
set(h, 'LineWidth', 1.0);
axis([ZoomMin ZoomMax 0 20]);
grid
xlabel('Time (mS)')
title('Approximation')


set(gcf, 'CurrentAxes', hRecov);
hold on
h = plot([idxRecov idxRecov], [0 20], 'b');
set(h, 'LineWidth', 1.0);
hold off