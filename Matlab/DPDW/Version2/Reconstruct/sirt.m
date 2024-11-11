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
%  $Date: 2004/01/03 08:26:08 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: sirt.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:08  rickg
%  Matlab Source
%
%  Revision 1.3  1998/09/14 18:43:38  rjg
%  Added the ability to compute many iteration estimates.
%
%  Revision 1.2  1998/06/03 16:15:33  rjg
%  Changed while loop to for loop.
%  Combined current x assignement and division by the number of rows for
%  the average step direction inside the loop.
%
%  Revision 1.1  1998/04/29 15:56:43  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function x = sirt(A, b, xinit, nIter)

[nr nc] = size(A);
nEst = length(nIter);

%%
%%  Default arguments
%%
if nargin < 4
    nIter = 10 * nr;
    if nargin < 3
        xinit = zero(nc, 1);
    end
end
x = zeros(nc, nEst);

%%
%%  Precompute the row norm
%%
rownorm = zeros(nr,1);
for i=1:nr,
    rownorm(i) = A(i,:) * A(i,:).';
end

%%
%%  Loop over the number of iterations requested
%%
for j = 1:nEst
    if j == 1
        x(:, j) = xinit;
        N = nIter(1);
    else
        x(:,j) = x(:,j-1);
        N = nIter(j) - nIter(j-1);
    end

    %%
    %%  Iterate over each row
    %%

    for i = 1:N
        RelResid = (A*x(:,j) - b) ./ rownorm;
        xnew = zeros(nc, 1);
        for iRow = 1:nr
            xnew = xnew + (x(:,j) - RelResid(iRow) * A(iRow,:).');
        end
        x(:,j) = xnew ./ nr;
    end
end
