%STEPCG         CG algorithm that displays the result at each iteration
%
%   [x, nIter, P] = cg(A, b, Po, epsilon, xtrue, AbigT, dr, R)
%
%
%   Calls: mslice
%
%   Bugs: none known.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/03 08:25:09 $
%
%  $Revision: 1.1.1.1 $
%
%  $Log: stepcg.m,v $
%  Revision 1.1.1.1  2004/01/03 08:25:09  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [x, nIter, P] = stepcg(A, b, Po, epsilon, xtrue, AbigT, dr, R)

if nargin < 4,
    epsilon = 1E-5
end
P(:,1) = Po;
r = b - A * Po;
mu = r;
err = sqrt(r' * r);
nIter = 2;
while err > epsilon
    alpha = (mu' * r) / (mu' * A * mu);
    P(:,nIter) = P(:,nIter-1) + alpha * mu;
    bigX = AbigT * P(:, nIter);
    mslice(bigX, dr, R, [1:11], [3 4]);
    drawnow;
    pause(1)
    r = b - A * P(:,nIter);
    err = sqrt(r' * r);
    beta = (mu' * A * r) /  (mu' * A * mu);
    mu = r - beta * mu;
    
    nIter = nIter + 1;
end
nIter = nIter - 1;
x = P(:, nIter);

