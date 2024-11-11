%ART            Algebraic Reconstruction Technique
%
%   x = art(A, b, xo, nIter, iRow)
%
%   x           The estimate of the x vector.
%
%   A           The forward matrix.
%
%   b           The measured data.
%
%   xinit       OPTIONAL: An initial guess, if not supplied then 0 will be
%               used.
%
%   nIter       OPTIONAL: The maximum number of iterations to compute
%               (default 10 * number of rows).  If nIter is a vector and
%               estimate is returned for each element in nIter.  The number
%               of iterations must be increasing.
%
%   iRow        OPTIONAL: The initial row to project onto.  Useful for
%               examining convergence performance.
%
%   Calls: none.
%
%   Bugs: the first projection does not appear to reach the (or some times
%   goes past) the hyperplane defined by the first row.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:26:06 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: art.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:06  rickg
%  Matlab Source
%
%  Revision 1.3  1999/01/04 22:00:35  rjg
%  Fixed help text.
%
%  Revision 1.2  1998/09/14 18:43:03  rjg
%  Added the ability to process many iteration estimates.
%
%  Revision 1.1  1998/06/03 16:08:15  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function x = art(A, b, xinit, nIter, CurrRow)

[nr nc] = size(A);
nEst = length(nIter);

%%
%%  Default arguments
%%
if nargin < 5
    CurrRow = 1;
    if nargin < 4
        nIter = 10 * nr;
        if nargin < 3
            xinit = zeros(nc, 1);
        end
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
        x(:,j) = x(:,j) - (A(CurrRow,:) * x(:,j)  - b(CurrRow)) / ...
            rownorm(CurrRow) * A(CurrRow,:)';
        CurrRow = CurrRow + 1;
        if CurrRow > nr
            CurrRow = 1;
        end
    end
end
