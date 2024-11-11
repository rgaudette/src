%corrcoefseq
%
%   ccSeq = corrcoefseq(x, y, spatialMask, ccMask)
%
%   ccSeq       The correlation coefficient sequence
%
%   x,y         The n-dimensional sequences for which the the correlation
%               coefficient will be calculated.
%
%   spatialMask The spatial mask to be applied to the y sequence
%
%   ccMask      OPTIONAL: The mask to apply to the correlation coeffiecient
%               sequence.  Useful for masking out aliased (wrapped)
%               correlation coefficient regions due to the use of the
%               circulant correlation function.
%
%   corrcoefseq computes the correlation coefficient between two sequences
%   over the masked region specified by spatialMask.  The mask is applied
%   to the y sequence and the x sequence is effectively shifted across the
%   masked region and the correlation coefficient computed only from that
%   region.
%
%   Calls: none
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/01/11 23:59:09 $
%
%  $Revision: 1.2 $
%
%  $Log: corrcoefseq.m,v $
%  Revision 1.2  2005/01/11 23:59:09  rickg
%  Correct number of mask elements
%
%  Revision 1.1  2005/01/04 05:09:24  rickg
%  *** empty log message ***
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function ccSeq = corrcoefseq(x, y, spatialMask, ccMask)

% Apply the spatial mask to the y function
nMask = sum(spatialMask(:));
invNMask = 1 / nMask;
yMask = y .* spatialMask;
yMaskVec = y(logical(spatialMask));
yMaskVec = yMaskVec(:);
meanY = mean(yMaskVec);
varY = invNMask * sum((yMaskVec - meanY) .^ 2);

% Compute the local mean and variance of x
X = fftn(x);
S_MASK_C = conj(fftn(spatialMask));
meanX = invNMask * ifftn(X .* S_MASK_C);
varX = invNMask * ifftn(fftn(x .^ 2) .* S_MASK_C) - meanX .^ 2;

% Compute the correlation coefficient using the quantities from above
numer = invNMask * ifftn(X .* conj(fftn(yMask))) - meanX .* meanY;
denom = sqrt(varX .* varY);
ccSeq = real(fftshift(numer ./ denom));

if nargin > 3
  ccSeq = ccSeq .* ccMask;
end
