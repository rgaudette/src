%GRADDESC       Gradient descent solution to Ax=b.
%
%   x = graddesc(A, b, x_o, thresh, nResid)
%
%   x           The solution to the system of equations.
%
%   A,b         The system to be solved.
%
%   x_o         OPTIONAL: An initial guess of the solution (defualt: 0).
%
%   thresh      OPTIONAL: The stopping threshold.  WHen the squared 2-norm
%               of the residual is below this value the routine returns the
%               solution (default: 1E-10).
%
%   nResid      OPTIONAL: The number of iteration to compute between updating
%               the true residual value (default: 50).
%
%
%   GRADDESC computes the gradient descent solution the system of linear
%   equations given by A and b.  Where A is a square, symmetric, positive
%   definite matrix.  Most likely the CG algorithm will provide better 
%   convergence than this algorithm.
%
%   Calls: none.
%
%   Bugs: unproven for complex systems.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:08 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: graddesc.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:08  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [x, i]  = graddesc(A, b, x, thresh, nResid)

if nargin < 5
    nResid = 50;
    if nargin < 4
        thresh = 1E-10;
        if nargin < 3
            [nr nc] = size(A);
            x = zeros(nc, 1);
        end
    end
end

r = b - A * x;
beta = r' * r;

i = 1;
while beta > thresh
    gamma = A * r;
    alpha = beta ./ (r' * gamma);
    x = x + alpha * r;
    if rem(i, nResid) == 0
        r = b - A * x;
    else
        r = r - alpha * gamma;
    end
    beta = r' * r;
    i = i + 1;
end

