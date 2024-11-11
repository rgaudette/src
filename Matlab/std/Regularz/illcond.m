%ILLCOND         Generate a an ill-conditioned matrix.
%
%    A = illcond(n, K)
%
%    A   An ill-conditioned matrix.
%
%    n   The size of the matrix to generate. If n is a scalar A will be nxn,
%        if n is a vector [M N], a will be MxN.
%
%    K   A request for the condition number.


function A = illcond(n, CondNumber)

sn  = length(n);

if sn == 1,
    n = [n n];
end

%%
%%  Create a random matrix
%%
A = randn(n);

%%
%%  Modify the singular values
%%
[U S V] = svd(A);
svec = diag(S);
svec = linspace(max(svec)/CondNumber, max(svec), length(svec));
svec = flipud(svec(:));
S([1:length(svec)], [1:length(svec)]) = diag(svec);
A = U * S * V';

