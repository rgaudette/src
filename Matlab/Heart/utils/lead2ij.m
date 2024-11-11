%LEAD2IJ        Convert a lead to a row column pair for a plaque array.
%
%   [idxRows idxCols] = lead2ij(idxLeads, nRows)
%
%   idxRows     The row indices of the leads.
%
%   idxCols     The column indices of the leads.
%
%   idxLeads    The lead idices to be converted.
%
%   nRows       The number of rows in the array.
%
%   LEAD2IJ converts a set of lead indices to row, column indices.  This assumes
%   that the data runs down each column first.  The row and column indices start
%   at 1 (FORTAN/MATLAB convention as opposed to C).

function [idxRows, idxCols] = lead2ij(idxLeads, nRows)

%%
%%  Compute the row indices of the leads.
%%
idxRows = rem(idxLeads - 1, nRows) + 1;

%%
%%  Compute the column indices of the leads.
%%
idxCols = ceil(idxLeads / nRows);
