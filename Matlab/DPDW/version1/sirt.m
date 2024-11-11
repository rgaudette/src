%SIRT           Simultaneous iterative reconstruction technique
%
%   x = sirt(A, b, xo, nIter)
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
%
%   SIRT
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:59 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: sirt.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:59  rickg
%  Matlab Source
%
%  Revision 1.2  1998/06/03 16:15:33  rjg
%  Changed while loop to for loop.
%  Combined current x assignement and division by the number of rows for the average step direction inside the loop.
%
%  Revision 1.1  1998/04/29 15:56:43  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function x = sirt(A, b, x, nIter)

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

for iIter = 1:nIter
    RelResid = (A*x - b) ./ rownorm;
    xnew = zeros(nc, 1);
    for iRow = 1:nr
        xnew = xnew + (x - RelResid(iRow) * A(iRow,:).');
    end
    x = xnew ./ nr;
end
