%PLT_TPK       Plot the peak twave values
%
%   hLines = plt_tpk(tpk, szArray, Title, flgLabel, LeadInfo)
%
%   hLines      Handles to the lines plotted in the contour routine.
%
%   ARI         The activation-recovery-interval for each lead.
%
%   szArray     The size of the array.
%
%   Title       A title for the plot.
%
%   flgLabel    [OPTIONAL] Manually label the contour lines if this is
%               non-zero (default: 0).
%
%   LeadInfo    [OPTIONAL] A structure containing the sampling period and
%               spacing and the stimulation time.  The members names are
%               TSamp, XSamp, YSamp, and TStim respectively (defaults:
%               1,1,1,0 respective).
%

function hLines = plt_ari(tpk, szArray, Title, flgLabel, LeadInfo)

%%
%%  Initialization
%%
if nargin < 5
    LeadInfo.TSamp = 1;
    LeadInfo.XSamp = 1;
    LeadInfo.YSamp = 1;
    LeadInfo.TStim = 0;
    
    LeadInfo.nRows = szArray(1);
    LeadInfo.nCols = szArray(2);
end
if nargin < 4,
    flgLabel = 0;
end

clf
orient tall

%%
%%  Compute the position of each lead with respect to the upper left of the
%%  array
%%
xPos = [1:LeadInfo.nCols];
yPos = [1:LeadInfo.nRows];

%%
%%  Generate the isochrones and label the axis
%%
minTpk = min(tpk);
maxTpk = max(tpk);
Isochrones = reshape(tpk, LeadInfo.nRows, LeadInfo.nCols);
hLines = contour(xPos, yPos, Isochrones, [0:.5:maxTpk], 'k');
set(gca, 'colororder', [1 1 1]);
set(gca, 'YDir', 'Reverse');
axis image
grid off
hGrid = mygrid;

if nargin < 5
    xlabel('Column Index')
    ylabel('Row Index')
else    
    xlabel('Column Index')
    ylabel('Row Index')
    %xlabel('X Position (mm)')
    %ylabel('Y Position (mm)')
end

if nargin > 2,
    title(Title);
end

%%
%%  Label the contour lines if requested
%%
if flgLabel ~= 0,
    clabel(hLines, 'manual');
end
