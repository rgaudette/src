%TIKHONOV        Direct computation of Tikhonov Regularization for Ax = b.
%
%    x = tikhonov(A, b, lambda)
%
%    x        The regularized solution.
%
%    A	      The ill-conditioned operator matrix.
%
%    b        The observation values.
%
%    lambda   The regularization parameter.

function x = tikhonov(A, b, lambda)


%%
%%    Compute answer for the transformed system of equations.
%%
b = A' * b;
A = A' * A;
x =  inv(A + lambda^2 * eye(size(A))) * b;
