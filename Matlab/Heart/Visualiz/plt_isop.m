%PLT_ISOP       Plot Isopotential lines for an array data structure
%
%   hLines = plt_isop(Array, idxSample, LineStep);
%
%   hLines      Handles to the contour lines (for use with clabel).
%
%   Array       The array data structure to be displayed.
%
%   idxSample   The temporal index to plot.
%
%   LineStep    OPTIONAL: The step size to use between lines (default: 5).
%
%
%   PLT_ISOP Plots isopotential lines.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:24:51 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: plt_isop.m,v $
%  Revision 1.1.1.1  2004/01/03 08:24:51  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function hLines = plt_isop(Array, idxSample, LineStep)

if nargin < 3
    LineStep = 5;
end

%%
%%  Extract the time requested
%%
PDist = reshape(Array.data(:, idxSample), Array.nRows, Array.nCols);
minPDist = matmin(PDist)
maxPDist = matmax(PDist)

axis([1 Array.nCols 1 Array.nRows]);

if maxPDist > 0,
    PosLines = [0:LineStep:maxPDist];
else
    PosLines = [];
end

if minPDist < 0,
    NegLines = [0:-1*LineStep:minPDist];
else
    NegLines = [];
end

hold on
if ~isempty(PosLines)
    contour(PDist, PosLines, 'r');
end
if ~isempty(NegLines)
    contour(PDist, NegLines, 'g--');
end

grid on
set(gca, 'box', 'on');
set(gca, 'ydir', 'reverse');
hold off