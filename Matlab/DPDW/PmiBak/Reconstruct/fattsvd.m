%FATTSVD        Truncated SVD solution to a fat matrix problem.
%
%   [xtsvd U S V]= fattsvd(A, b, r, U, S, V)
%
%   xtsvd       The estimate of x (n x 1).
%
%   U,S,V       The singular value decomposition of A.  If this is supplied
%               on the right hand side it will not be computed.  If only 3
%               input arguments are supplied the economy SVD will be
%               computed.
%
%   A           The system matrix (m x n).  This should not be overdetermined
%               (m <= n).
%
%   b           The measurement vector (m x 1).
%
%   r           The truncation parameter (1 <= r <= m).
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:36 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: fattsvd.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:36  rickg
%  Matlab Source
%
%  Revision 1.3  1999/02/15 19:42:43  rjg
%  Added ability to handle tall and square problems correctly.
%
%  Revision 1.2  1998/12/22 16:55:56  rjg
%  Updated help section.
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
    [m n] = size(A);
    if m < n
        [V S U] = svd(A', 0);
    else
        [U S V] = svd(A, 0);
    end
end
xtsvd = V(:,1:r)* (diag(S(1:r,1:r)).^-1 .* ((U(:,1:r))' * b));
