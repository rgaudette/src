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
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:27:14 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: art_test.m,v $
%  Revision 1.1.1.1  2004/01/03 08:27:14  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function x = art(A, b, x, nIter, flgSaveOld)

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
if flgSaveOld
    x = zeros(nc, nIter);
end
CurrRow = 1;
xold = zeros(1,1);

for iIter = 1:nIter
    x(:,iIter) = xold - ...
        (A(CurrRow,:)*xold  - b(CurrRow)) / rownorm(CurrRow) * A(CurrRow,:)';
    CurrRow = CurrRow + 1;
    xold = x(:,iIter);
    if CurrRow > nr
        CurrRow = 1;
    end
end
