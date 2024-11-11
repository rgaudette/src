%TCGLS          Truncated CG algorithm for solving A'Ax = A'b.
%
%   [x r] = tcgls(A, b, nIter)
%
%   x           The estimate(s) of the x vector.
%
%   r           The residual vector.
%
%   A           The forward matrix.
%
%   b           The measured data.
%
%   nIter       OPTIONAL: The maximum number of iterations to compute
%               (default 10 * number of rows).  If nIter is a vector and
%               estimate is returned for each element in nIter.  The number
%               of iterations must be increasing.
%
%   TCGLS computes the truncated conjugate gradient solution on the
%   normal equations without explicitly forming the normal equations.
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
%  $Log: tcgls.m,v $
%  Revision 1.1.1.1  2004/01/03 08:26:08  rickg
%  Matlab Source
%
%  Revision 1.0  1998/09/22 18:04:03  rjg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [x, r] = tcgls(A, b, nIter)
[m n] = size(A);
nEst = length(nIter);

%%
%%  Initalizations
%%
bproj = A' * b;
r = bproj;
d = r;
delta_new = r' * r;
d_o = delta_new;

%%
%%  Loop over the number of iterations requested
%%
for j = 1:nEst
    if j == 1
        x(:, j) = zeros(n, 1);
        N = nIter(1);
    else
        x(:,j) = x(:,j-1);
        N = nIter(j) - nIter(j-1);
    end

    %%
    %%  Iterate over each row
    %%
    for i = 1:N
        q = A' * (A * d);
        alpha = delta_new / (d' * q);
        x(:,j) = x(:,j) + alpha * d;
        if rem(i, 50) == 0
            r = bproj - A' * (A * x(:,j));
        else
            r = r - alpha * q;
        end
        delta_old = delta_new;
        delta_new = r' * r;
        beta = delta_new / delta_old;
        d = r + beta * d;
    end
end

