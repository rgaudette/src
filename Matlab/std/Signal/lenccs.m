%lenccs         Local energy normalized cross-correlation sequence
%
%   [r lr, lc, lp] = lenccs(p, s, p_l, p_h, SSQ)
%
%   r           The local energy normalized cross-correlation sequence.
%
%   lr, lc, lp  The lag for each element of the cross-correlation sequence.  For
%               the row, column, and plane dimensions respectively.  Only those
%               dimensions that apply to the input data are returned.
%
%   p, s        The arrays to cross correlate, must be the same number of
%               dimensions.  If p is complex it is assumed to be the fft of p
%               at the same size as s.  If s is complex it is assumed to contain
%               the complex conjugate of the n-dimensional fft of s.
%
%   p_l, p_h    OPTIONAL: The indices of the first and last elements of the
%               support of p for each dimension. These are used to calculate the
%               range of valid lags where the circulant cross-correlation is
%               equivalent to the linear cross-correlation.
%               (default: p_l=0, p_h=size(p)).
%
%   cSSQ        OPTIONAL:  If s is supplied in the frequency domain then cSSQ
%               should contain the conjugate of the Fourier transform of s^2.
%
%   Bugs: currently limited to 3 or less dimensions but trivial to extend.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/07/28 23:27:01 $
%
%  $Revision: 1.3 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [r lr lc lp] = lenccs(p, s, p_l, p_h, cSSQ)

nDim = ndims(s);
if nDim == 2 && any(size(s) == 1)
  nDim = 1;
  s = s(:);
  nS = length(s);
  p = p(:);
else
  nS = size(s);
end

if nargin < 3
  p_l = ones(1, nDim);
end
if nargin < 4
  if nDim == 1
    p_h = length(p);
  else
    p_h = size(p);
  end
end

mask = zeros(size(p));
switch nDim
  case 1
    % Compute the cross-correlation sequence and the mask
    [ccs lr] = xcorrFD(p, s, p_l, p_h);
    mask(p_l:p_h) = 1;

  case 2
    [ccs lr lc] = xcorrFD(p, s, p_l, p_h);
    mask(p_l(1):p_h(1), p_l(2):p_h(2)) = 1;
    
  case 3
    [ccs lr lc lp] = xcorrFD(p, s, p_l, p_h);
    mask(p_l(1):p_h(1), p_l(2):p_h(2), p_l(3):p_h(3)) = 1;
    
  otherwise
    error('Arrays greater than three dimensions not yet implemented');
end

% Find the local energy of the two sequences, p is trivial since it does not
% shift relative to the lag.  The local energy of s is computed by shifting s
% across a 0-1 mask that defines the support of p.
if isreal(s)
  sNRG = abs(xcorrFD(mask, s.^2, p_l, p_h));
else
  sNRG = abs(xcorrFD(mask, cSSQ, p_l, p_h));
end
nElem = prod(size(p));
p = p(:);
if isreal(p)
  pNRG = sum(p .^ 2);
else
  pNRG = sum(p .* conj(p)) / nElem;
end
r = ccs ./ sqrt(pNRG .* sNRG);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: lenccs.m,v $
%  Revision 1.3  2005/07/28 23:27:01  rickg
%  cSSQ needs to be supplied as the conj
%
%  Revision 1.2  2005/05/20 15:58:45  rickg
%  Comment fixes
%
%  Revision 1.1  2005/05/12 17:47:59  rickg
%  *** empty log message ***
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
