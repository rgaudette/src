%RTPIVOT        Ratio test pivot
%
%   [Aout flag] = rtpivot(Ain, nConst)
%
%   Aout        The pivoted system
%
%   flag        Returns zero if the system is updated, one if the system is
%               already optimized, 2 if the system is unbounded.
%   Ain         The system to be pivoted
%
%   nConst      OPTIONAL: The number of constraint rows.  Use this to specify if
%               there are multiple cost rows (default: M-1, where M is the
%               number of rows in Ain).  If multple cost functions are supplied the
%               last constraint row will be the one that is optimized for.
%
%   RTPIVOT returns a pivoted system, Aout, with a new basic variable decided by
%   the ratio test.  The last column of the system of Ain should be the RHS of
%   the equality constraint.  The last row of the system Ain should be cost
%   function.  The output system Aout has the same form.  This routine assumes
%   that Ain is in cannonical form.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:46 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: rtpivot.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:46  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Aout, flag] = rtpivot(Ain,  nConst)

[m n] = size(Ain);
if nargin < 2
    nConst = m-1;
end

flag = 0;

%%
%%  Find the first positive cost coefficient where at least one constraint
%%  coeffiecient on the same variable is positive.
%%
iPosCost = find(Ain(m, :) > 0);
flgUnBound = 1;
for iChkBnd = iPosCost
    iPos = find(Ain(1:nConst, iChkBnd) > 0);
    if ~isempty(iPos)
        flgUnBound = 0;
        break;
    end
end
if flgUnBound
    flag = 1;
    Aout = Ain;
    return
end


%%
%%  Ratio test the selected variable
%%
[ratio iMinRatio] = min(Ain(iPos, n) ./ Ain(iPos, iChkBnd));
iPivotRow = iPos(iMinRatio);
ratio
disp(['Outgoing basic variable row ' int2str(iPivotRow)]);
disp(['Incoming basic variable x' int2str(iChkBnd)])

%%
%%  Pivot the system so that lowest ratio tested row contains the outgoing
%%  basic variable and the incomining basic variable is the selected column
%%
Aout = zeros(m, n);
for iRow = 1:m
    if iRow == iPivotRow
        Aout(iRow, : ) = Ain(iRow,:) ./ Ain(iRow, iChkBnd);
    else
        Aout(iRow, :) = Ain(iRow, :) - Ain(iRow, iChkBnd) / Ain(iPivotRow, ...
            iChkBnd) * Ain(iPivotRow, :);
    end
end

