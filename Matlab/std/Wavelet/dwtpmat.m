%DWTPMAT        Perform a periodized DWT along the columns of a matrix.
%
%   [W ScMap] = dwtpmat(X, Approx, Detail, nDecomp)
%
%   W           The WT coeffiecients.  The finest scale coeffiecients are first
%
%   ScMap       A vector containing the number of samples saved in the Datail
%               convolution and if this is the last stage, the number for the
%               the approximation convolution.
%
%   X	        The sequences to be transformed, each column represents a
%               sequence.
%
%   Approx      The approximation or scaling function coefficients,
%               these will be reversed for use with "filter".
%
%   Detail      The detail or wavelet coefficients, these will also be
%               reversed for use with "filter".
%
%   nDecomp     [OPTIONAL] The number of decompositions to perform on the
%               sequence.  The length of the sequence must be divisible by 2
%               this many times.  The default value is a full decomposition.

function [W, ScMap] = dwtpmat(X, Approx, Detail, nDecomp)

[nSamples nSequences] = size(X);

for iSeq = 1:nSequences,
    if nargin < 4,
        [W(:,iSeq) ScMap] = dwtp(X(:,iSeq), Approx, Detail);
    else
        [W(:,iSeq) ScMap] = dwtp(X(:,iSeq), Approx, Detail, nDecomp);
    end
end
