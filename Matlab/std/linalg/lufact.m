%LUFACT         Perform LU factorization (using for loops)
%
%   [L U] = lufact(X, flgShow)
%
%   LUFACT will pause at the end of each for loop if flgShow is set.
%   (default = 0)
%
%   Note: this relies on the property that the inverse of a an elementary
%   operation matrix is the original operation matrix with the constant
%   multiplied by negative one. 
%
%       E(n) * E(n-1) * ... * E(1) * A = U
%
%       A = (E(n) * E(n-1) * ... * E(1))^-1 * U
%       A = E(1)^-1 * ... * E(n-1)^-1 * E(N)^-1 * U
%       A = L * U
function [L, U] =  lufact(X, flgShow)

if nargin < 2,
    flgShow = 0;
end

[m n] = size(X);

if m ~= n,
    error('lufact: X must be sqaure matrix');
end

%%
%%
%%
L = eye(m);

for i = [2:m],
    for j = [1:i-1,],

        %%
        %%  Compute lower triangular multiplier
        %%
        L(i,j) = X(i,j) / X(j,j);

        %%
        %%  Operate on X with lower triangular multiplier
        %%      (e I)X = X'
        %%        n
        %%
        X(i,:) = -1 * L(i,j) * X(j,:) + X(i,:);

        %%
        %%  Dispaly intermediate results if requested
        %%
        if flgShow,
            fprintf('i:%d\tj:%d\tl:%f\n', i, j, L(i,j));
            L
            X
            pause
        end
    end
end

%%
%%  Resultant X is upper triangular
%%
U = X;

