%TRECPERF       Fiducial time performance evaluation.
%
%   hAxes = trecperf(Decomp, Peaks, Regions, Lead, LastScale)

function hAxes = trecperf(Decomp, Peaks, Regions, Lead, LastScale)

[nSamps nDecomp] = size(Decomp);

if nargin > 3,
    nPlots = nDecomp;
    PlotOffset = 1;
else
    nPlots = nDecomp - 1;
    PlotOffset = 0;
end

hAxes = zeros(nPlots, 1);

%%
%%  Plot the raw lead data with the estimate
%%
if nargin > 3,
    hAxes(1) = subplot(nPlots, 1, 1);
    plot(Lead);
    hold on
    plot(Peaks(LastScale), Lead(Peaks(LastScale)), 'ro');

end

for iPlot = 1:nDecomp-1
    hAxes(iPlot+PlotOffset) = subplot(nPlots, 1, iPlot+PlotOffset);

    %%
    %%  Plot the mallat decomposition scale
    %%
    plot(Decomp(:, iPlot));
    hold on
    Axis = axis;

    %%
    %%  Plot the peak selection if present
    %%
    if Peaks(iPlot) ~= 0
        plot(Peaks(iPlot), Decomp(Peaks(iPlot), iPlot), 'ro');
    end

    %%
    %%  Plot the search region if present
    %%
    if  (iPlot < (nDecomp-1)) & (Regions(2, iPlot) ~= 0) 
        plot([Regions(1,iPlot) Regions(1,iPlot)], [Axis(3) Axis(4)], 'g', 'LineWidth', 2);
        plot([Regions(2,iPlot) Regions(2,iPlot)], [Axis(3) Axis(4)], 'g', 'LineWidth', 2);
    end
    
end

