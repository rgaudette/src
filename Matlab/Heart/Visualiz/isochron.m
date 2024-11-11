%ISOCHRON       Generate & display isochrones.
%
%   [C idxAct] = isochrone(Data)
%
%   C           The countour lines as returned from MATLAB's contour
%               function.
%
%   idxAct      The index of the activation time (largest first difference)
%               for each lead.  This is a matrix strucured like the leads.
%
%   Data        The potential data array, each row should be a different lead,
%               each column a different time instant.  The lead array is
%               assumed to be square.
%
%   ISOCHRONE perfoms a simple isochrone estimate for an array of cardiac
%   leads.  The activation time is estimated by finding the largest negative
%   first difference value for each lead.  Using the contour function the lead
%   array is assumed to be sqaure.

function [C, idxAct] = isochrone(Data)

%%
%%    Assume image is square
%%
[nElems nSamples] = size(Data);
nRows = sqrt(nElems);
nCols = nElems / nRows;

%%
%%  Find the time index of the largest negative first difference value.
%%
Diff = diff(Data');
[NegPeak idx] = min(Diff);

%%
%%  Reshape the matrix into the structure of the leads
%%
idxAct = reshape(idx, nRows, nCols);

%%
%%  Plot contours in index units
%%
Start = matmin(idxAct);
Stop = matmax(idxAct);
C = contour(flipud(idxAct), [Start:1:Stop]);
grid
xlabel('Column Index');
ylabel('Row index');

