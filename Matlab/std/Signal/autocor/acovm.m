%ACOVM     Compute the autocovariance matrix for a sequence.
%
%   A = acov(x)

function A = acov(x, nBlocks)

if nargin < 1,
    nBlocks = 1;
end

%%
%%  Divide the data into the correct number of blocks
%%
lBlk = floor(length(x) / nBlocks);
x = x(1:lBlk * nBlocks);
x = reshape(x, lBlk, nBlocks);

%%
%%  Compute a covariance matrix for each block, average the matricies.
%%
A = zeros(lBlk, lBlk);
for i = 1: nBlocks,
    xc = xcov(x(:,i));
    lxc = length(xc);
    xc = xc([ceil(lxc/2):lxc]);
    A = A + toeplitz(xc);
end

A = A ./ nBlocks;
