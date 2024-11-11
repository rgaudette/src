%ART            Algebraic Reconstruction Technique
%
%   x = art(A, b, xo, nIter)
%
%   x           The estimate of the x vector.
%
%   A           The forward matrix.
%
%   b           The measured data.
%
%   xo          OPTIONAL: An initial guess, if not supplied then 0 will be
%               used.
%
%   nIter       OPTIONAL: The maximum number of iterations to compute
%               (default 10 * number of rows).
%
%   Calls: none.
%
%   Bugs: the first projection does not appear to reach the (or some times
%   goes past) the hyperplane defined by the first row.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:56 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: art.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:56  rickg
%  Matlab Source
%
%  Revision 1.1  1998/06/03 16:08:15  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function x = art(A, b, x, nIter)

[nr nc] = size(A);

%%
%%  Default arguments
%%
if nargin < 4
    nIter = 10 * nr;
    if nargin < 3
        x = zero(nc, 1);
    end
end

%%
%%  Precompute the row norm
%%
rownorm = zeros(nr,1);
for i=1:nr,
    rownorm(i) = A(i,:) * A(i,:).';
end
CurrRow = 1;
xold = zeros(1,1);

for iIter = 1:nIter
    x = x - (A(CurrRow,:)*x  - b(CurrRow)) / rownorm(CurrRow) * A(CurrRow,:)';
    CurrRow = CurrRow + 1;
    if CurrRow > nr
        CurrRow = 1;
    end
end
