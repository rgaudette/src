%CRCOVCOF       Cross covariance coefficient.
%
%   C = crcovcof(X)
%
%   X       The sequences to compare, each sequence in its own column.
%
%   C       The cross covariance matrix.
%
%   CRCOVCOF computes the cross covariance coefficient of number of sequences.
%   Each sequence should occupy a column within X.  
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:19 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: crcovcof.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:19  rickg
%  Matlab Source
%
%  Revision 1.1  1997/07/31 19:10:56  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function C = crcovcof(x)

[nr nc] = size(x);

%%
%%  Compute the mean of each column.
%%
mx = mean(x);

%%
%%  Remove each column's mean
%%
x = x - ones(nr, 1) * mx;

%%
%%  Compute the standard deviation of each column & the cross covariance
%%  coefficient.
%%
stddev = std(x);
C = (x'*x) ./ (stddev' * stddev)./ (nr-1);