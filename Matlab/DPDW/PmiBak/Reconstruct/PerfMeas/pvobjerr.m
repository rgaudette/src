%PVOBJERR       Peak Value Error over the object region
%
%   err = pvobjerr(true, est)
%
%   err         The error as a function the estimate index.
%
%   true        The true value of the vector.
%
%   est         The set of estimates of the vector, each estimate is a
%               seperate column in this matrix.
%
%
%   PVERR computes the absolute value of the difference in peak value between
%   the true function and a number of estimates.
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
%  $Log: pvobjerr.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:38  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function err = pvobjerr(true, est)
obj = true > 0;
err = abs(max(est(obj,:)) - max(true(obj,:)));
