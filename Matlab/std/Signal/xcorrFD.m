%xcorrFD        Cross-correlation function computed in the frequency domain.
%
%   [r lr lc lp] = xcorrFD(x, y, x_first, x_last)
%
%   r           The cross-correlation sequence.
%               The sequence is only calculated for shifts where y xolly
%               overlaps x.
%
%   lr, lc, lp  The lag for each element of the cross-correlation sequence.  For
%               the row, column and plane dimensions resepctively.  Only those
%               dimensions that apply to the input data are returned.
%
%   x, y        The arrays to cross correlate
%               The  must be the same number of dimensions.  
%               The origin for both arrays is assumed to coincide with the
%               first element. 
%               Each dimension of x must not be greater than the equivalent
%               dimension in y.
%               If x is complex it is assumed to be the FFT of x at the same
%               size as y.
%               If y is complex it is assumed to contain the complex
%               conjugate of the n-dimensional FFT of y.
%               Implies only real signals can be processed
%
%   x_first, x_last    OPTIONAL: The indices of the first and last elements of the
%               support of x for each dimension. These are used to calculate the
%               range of valid lags where the circulant cross-correlation is
%               equivalent to the linear cross-correlation.
%               (default: x_first=1, x_last=size(x)).
%
%   xcorrFD computes the cross-correlation function of the arrays x 
%   and y using a frequency domain calculation. Specifcally:
%
%     r = circshift(ifftn(fftn(x, size(y)) .* conj(fftn(y))), -lmin)
%
%   the assumption being that x is shorter than y.
%
%   Bugs: currently limited to 3 or less dimensions but trivial to extend.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/12 17:47:41 $
%
%  $Revision: 1.4 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [r lr lc lp] = xcorrFD(x, y, x_first, x_last)

if ndims(x) ~= ndims(y)
  error('Both sequence must have the same number of dimensions')
end

nDim = ndims(y);
if nDim == 2 && any(size(y) == 1)
  nDim = 1;
  y = y(:);
  nY = length(y);
  x = x(:);
else
  nY = size(y);
end

if nargin < 3
  x_first = ones(1, nDim);
end

if nargin < 4
  if nDim == 1
    x_last = length(x);
  else
    x_last = size(x);
  end
end

% Compute the region of valid linear cross-correlation elements
% l is the lag value
lmin = x_last - nY;
lmax = x_first - 1;
nLags = lmax - lmin + 1;

% If the signal arguments are complex they are assumed to already be in the
% frequency domain
if isreal(y)
  Yconj = conj(fftn(y));
else
  Yconj = y;
end

if isreal(x)
  X = fftn(x, size(Yconj));
else
  X = x;
end

% Compute the circulant cross-correlation sequence
r_circ = real(ifftn(X .* Yconj));

% Circularly shift the result so that minimum lag is at the first index of the
% array
r_circ = circshift(r_circ, - lmin);

% Zero out the non valid elements for a linear cross-correlation
switch nDim
  case 1
    r = r_circ(1:nLags);
    lr = (lmin:lmax)';
  case 2
    r = r_circ(1:nLags(1), 1:nLags(2));
    lr = lmin(1):lmax(1)';
    lc = lmin(2):lmax(2);
  case 3
    r = r_circ(1:nLags(1), 1:nLags(2), 1:nLags(3));
    lr = lmin(1):lmax(1)';
    lc = lmin(2):lmax(2);
    lp = lmin(3):lmax(3);
  otherwise
    error('Arrays greater than three dimensions not yet implemented');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: xcorrFD.m,v $
%  Revision 1.4  2005/05/12 17:47:41  rickg
%  Change lag indices to vectors
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
