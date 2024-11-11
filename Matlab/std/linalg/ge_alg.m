%LUFACT         LU factorization (with for loops), pausing at each reduction.

function [L, U] =  ge_alg(x)

[m n] = size(x);

if m ~= n,
    error('lufact: X must be sqaure matrix');
end

Ltot = eye(m);

%%
%%
%%
for i = 2:m

    for j = 1:i-1,
        L = eye(m);
        fprintf('i:%d\tj:%d\n', i, j);
        L(i,j) = -1 * x(i,j) / x(j,j);

        x(i,:) = L(i,j) * x(j,:) + x(i,:)

        Ltot = L * Ltot;

    end
end

L = Ltot;
U = x;
