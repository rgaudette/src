%QUAN_LIN       Quan's method of linearly interpolating potentials.
%
%   NewArray = quan_lin(OldArray, szArray, tActiv, Rows, Cols, IRow, ICol)
%
%   NewArray    The interpolated plaque data.
%
%   OldArray    The original plaque data.
%
%   tActiv      The activation time for each lead, assumed to be a vector.
%
%   Rows        The location of each row of the original array.
%
%   Cols        The location of each column of the original array.
%
%   IRow        The location of the rows of the interpolated array.
%
%   ICol        The location of the columns of the interpolated array.

function NewArray = quan_lin(OldArray, szArray, tActiv, Rows, Cols, IRow, ICol)

%%
%%  Initializations
%%
IRow = IRow(:);
ICol = ICol(:)';

%%
%%  Find the difference between the maximum and minimum activation times.
%%  This is the amount of time lost off of each end of the signal due to the
%%  shifts.
%%
idxFirstAct = min(tActiv);
idxLastAct = max(tActiv);
TotalShift = idxLastAct - idxFirstAct;

%%
%%  Create a matrix that allows for the shift, fill with shifted signals
%%
[nLeads nSamps] = size(OldArray);
Shift = zeros(nLeads, nSamps + TotalShift);

for iLead = 1:nLeads,
    idxStart = idxLastAct - tActiv(iLead) + 1;
    Shift(iLead, idxStart:idxStart+nSamps-1) = OldArray(iLead,:);
end

%%
%%  At each (shifted) time interpolate spatially.
%%
nInterpLeads = length(IRow) * length(ICol);
NewShift = zeros(nInterpLeads, nSamps - TotalShift);
for iSamp = 1:nSamps - TotalShift
    temp = interp2(Cols, Rows, ...
        reshape(Shift(:,TotalShift + iSamp), szArray(1), szArray(2)), ...
        ICol, IRow);        
    NewShift(:, iSamp) = temp(:);
end

%%
%%  Shift the interpolated data back to it's appropriate time.
%%
intrpTAct = round(interp2(Cols, Rows, ...
    reshape(tActiv, szArray(1), szArray(2)), ICol, IRow));
intrpTAct = intrpTAct(:);
nInterpSamps = nSamps - 2 * TotalShift;
NewArray = zeros(nInterpLeads, nSamps - 2 * TotalShift);

for iLead = 1:nInterpLeads,
    idxStart = idxLastAct - intrpTAct(iLead) + 1;
    NewArray(iLead, :) = NewShift(iLead, idxStart:idxStart+nInterpSamps-1);
end
