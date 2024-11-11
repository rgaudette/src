%CGMN           Conjugate gradient algorithm for solving the min 2-norm Ax = b.
%
%   [xmn P flgStop] = cgmn(A, b, Po, epsilon, nIterMax)
%
%   xmn         The estimate of the minimum norm solution.
%
%   P           The estimate at each iteration of the minimum norm solution.
%
%   A, b        The under determined system to solve.
%
%   Po          The initial estimate of x.  This is transformed into the data
%               space by A.
%
%   epsilon     OPTIONAL: The stopping criterion. The algorithm completes
%               when the 2-norm squared of the residual is less than this
%               value.
%
%   nIterMax    OPTIONAL: The maximum number of iterations to perform.  This
%               allows a truncated solution to be computed.  
%
%   CGMN attempts to find the minimum norm solution to the underdetermined
%   system Ax = b.  It perfoms a (possibly truncated) CG search on the
%   normal equations for the minimum norm solution.  The minimum solution
%   can be expressed as
%
%       x_mn = A'z
%
%   where z is given by
%
%       (A * A') z = b.
%
%   Truncated CG is used to solve this system of equations.
%
%   Calls: none.
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:08 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: cgmn.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:08  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [xmn, Pmn, flgStop] = cgmn(A, b, Po, epsilon, nIterMax)

if nargin < 5
    nIterMax = inf;
    if nargin < 4
        epsilon = 1E-5;
    end
end


%%
%%  Transform initial estimate into data domain
%%
P(:,1) = A * Po;

r = b - A * (A' * P(:,1));
mu = r;
err = r' * r;

nIter = 2;
while (err > epsilon) & (nIter < nIterMax)
    gamma = (mu' * A) * (A' * mu);
    alpha = (mu' * r) / gamma;
    P(:,nIter) = P(:,nIter-1) + alpha * mu;
    r = b - A * (A' * P(:,nIter));
    beta = ((mu' * A) * (A' * r)) / gamma;
    mu = r - beta * mu;
    nIter = nIter + 1;
    err = r' * r;
end
nIter = nIter - 1;
z = P(:, nIter);

%%
%%  Transform the results to the min norm solution
%%
xmn = A' * z;

if nargout > 1
    Pmn = A' * P;
end

if err <= epsilon
    flgStop = 0;
else
    flgStop = 1;
end

