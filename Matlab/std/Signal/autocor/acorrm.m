%ACORRM     Compute the autocorrelation matrix for a sequence.
%
%   A = acorr(x)

function A = acorr(x, nBlocks)

if nargin < 1,
    nBlocks = 1;
end

%%
%%  Divide the data into the correct number of blocks
%%
lBlk = floor(length(x) / nBlocks);
x = x(1:lBlk * nBlocks);
x = reshape(x, lBlk, nBlocks);

A = zeros(lBlk, lBlk);

for i = 1: nBlocks,
    xc = xcorr(x(:,i));
    lxc = length(xc);
    xc = xc([ceil(lxc/2):lxc]);
    A = A + toeplitz(xc);
end

A = A ./ nBlocks;

