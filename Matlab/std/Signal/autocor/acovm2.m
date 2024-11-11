%ACOVM2     Compute the autocovariance matrix for a sequence.
%
%   A = acov(x)

function A = acov(x, lBlk)

if nargin < 1,
    lBlk = length(x);
end

x = x(:);
%%
%%  Divide the data into the correct number of blocks
%%
nBlocks = floor(length(x) / lBlk);
nBlocks = nBlocks - 2;
xmat = zeros(3*lBlk,nBlocks);
for i = 1:nBlocks,
    xmat(:,i) = x([(i-1)*lBlk+1:(i+2)*lBlk]);
end
    
%%
%%  Compute a covariance matrix for each block, average the matricies.
%%
A = zeros(lBlk, lBlk);
for i = 1: nBlocks,
    xc = xcov(xmat(:,i));
    lxc = length(xc);
    xc = xc([ceil(lxc/2):ceil(lxc/2)+lBlk-1]);
    A = A + toeplitz(xc);
end

A = A ./ nBlocks;
