%FATTSVD        Truncated SVD solution to a fat matrix problem.
%
%   [xtsvd U S V]= fattsvd(A, b, r, U, S, V)
%
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:57 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: fattsvd.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:57  rickg
%  Matlab Source
%
%  Revision 1.1  1998/04/29 17:17:45  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [xtsvd, U, S, V] = fattsvd(A, b, r, U, S, V)

%%
%%  Compute the economy SVD of the tall problem if necessary
%%
if nargin < 6
    [V S U] = svd(A', 0);
end
xtsvd = V(:,1:r)* (diag(S(1:r,1:r)).^-1 .* ((U(:,1:r))' * b));
