%BCKERR         Mean square background error for a set of estimates.
%
%   err = bckerr(xtrue, xest)
%
%   err         The mean square background error(s).
%
%   xtrue       The true value of the object function.
%
%   xest        The set of estimates to analyze.  Each estimate should be
%               in a seperate column.
%
%   BCKERR finds where the true object function is zero and computes the
%   mean square value of the estimates over those regions.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:38 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: bckerr.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:38  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function err = bckerr(xtrue, xest)
idxBckGrnd = find(xtrue == 0);
err = mean(xest(idxBckGrnd,:).^2);