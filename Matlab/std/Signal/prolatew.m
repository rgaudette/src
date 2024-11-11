%PROLATEW       Prolate-Spheroidal window function.
%
%   [w V] = prolatew(N, fc)
%
%   w   The prolate-spheroidal window.
%
%   V   The eigenvectors from the P matrix, sorted in ascening eigenvalue order.
%
%   N   The number of elements for the window.
%
%   fc  The cutoff point (normalized frequency).

function [w, V]= prolatew(N, fc)

%%
%%  Generate toeplitz matrix
%%
col = sin(2*pi*fc*[0:N-1]) ./ (pi*[0:N-1]);
col(1) = 1;

phi = toeplitz(col);

%%
%%  Compute the eigenvectors/eigenvalues of phi
%%
[V D] = eig(phi);

%%
%%  Find the largest eigenvalue, the associated eigenvector is the
%%  filter we are looking for.
%%
D = diag(D);
[D idxSort] = sort(D);
V = V(:, idxSort);
w = V(:,1);


