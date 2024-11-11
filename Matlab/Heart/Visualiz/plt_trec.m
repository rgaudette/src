%PLT_TREC       Plot the recovery time isochrones from a lead array.
%
%   [tRecov hLines] = plt_trec(Leads, szArray, Title, flgLabel, LeadInfo)
%
%   tRecov      The activation time for each lead.
%
%   hLines      Handles to the lines plotted in the contour routine.
%
%   Leads       Either the raw data leads in which case the activation time
%               is computed using the trecov3 algorithm, or the activation
%               times themselves.
%
%   szArray     The size of the array.
%
%   Title       A title for the plot.
%
%   flgLabel    [OPTIONAL] Manually label the contour lines if this is
%               non-zero (default: 0).
%
%
%   LeadInfo    [OPTIONAL] A structure containing the sampling period and
%               spacing and the stimulation time.  The members names are
%               TSamp, XSamp, YSamp, and TStim respectively (defaults:
%               1,1,1,0 respective).
%
%   Calls: trecov3

function [tRecov, hLines] = plt_trec(Leads, szArray, Title, flgLabel, LeadInfo)

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
%%  Compute the activation time index for each lead if they are not
%%  already computed
%%
[nLeads nSamples] = size(Leads);
if nSamples > 1,
    tActiv = trecov3(Leads, 5);
else
    tActiv = Leads;
end

%%
%%  Convert the index value into actual times with respect to the
%%  stimulation time
%%
tActiv = tActiv * LeadInfo.TSamp - LeadInfo.TStim;
tActMin = min(tActiv);
tActMax = max(tActiv);

%%
%%  Compute the position of each lead with respect to the upper left of the
%%  array
%%
xPos = [1:LeadInfo.nCols];% * LeadInfo.XSamp;
yPos = [1:LeadInfo.nRows];% * LeadInfo.YSamp;

%%
%%  Generate the isochrones and label the axis
%%
Isochrones = reshape(tActiv, LeadInfo.nRows, LeadInfo.nCols);
hLines = contour(xPos, yPos, Isochrones, [tActMin:2:tActMax], 'k');
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
