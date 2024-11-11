%xcorrSD        Cross-correlation function computed in the sample domain.
%
%   [r lags] = xcorrSD(p, s, l_in, p_l, s_l)
%
%   r           The cross-correlation sequence.
%
%   lags        The true lag for each element of the cross-correlation sequence,
%               given p_l and s_l.
%
%   p, s        The arrays to cross correlate, must be the same number of
%               dimensions.
%
%   l_in        OPTIONAL: The lags to be computed, they must be between
%               [-N_s + N_p, 0], default ([ ] = all).
%
%   p_l, s_l    The true indices of the first elements of p and s respectively
%               these will be used to compute the return lags vector through:
%
%                 lags = p_l - s_l + l,
%
%               default: 0.
%
%   xcorrSD computes the cross-correlation function of the arrays p 
%   and s using a sample domain calculation. Specifcally:
%
%                        N_p
%     r(k) = r(-l + 1) = sum  p(i) * s(i - l)  -N_s + N_p <= l <= 0
%                        i=1
%
%   Note: this function is primarily for demonstration and validation purposes
%   and has not been coded to be very efficient (i.e. vectorized).
%
%   Calls: none
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/05/06 16:41:07 $
%
%  $Revision: 1.1 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [r lags] = xcorrSD(p, s, l_in, p_l, s_l)

N_p = length(p);
N_s = length(s);

% Make sure p is a column vector and s is a row vector
if size(p, 2) == 1
  p = p.';
end
if size(s, 1) == 1
  s = s.';
end

if nargin < 3 || isempty(l_in)
  flgAllLags = 1;
  l_in = -N_s+N_p:0;
else
  flgAllLags = 0;
  if any(l_in < -N_s+N_p)
    error('lag values below %d were requested\n', -N_s+N_p)
  end
  if any(l_in > 0)
    error('lag values above 0 were requested\n')
  end
end

% Initialize the output array
N_r = N_s - N_p + 1;
r = zeros(N_r, 1);

% Compute the selected cross-correlation lags
idxP = 1:N_p;
for l = l_in
  r(N_r + l) = p * s(idxP - l);
end

% Extract the selected lags
if ~ flgAllLags 
  r = r(N_r + l_in);
end

if nargout > 1
  if nargin < 4
    p_l = 0;
  end
  if nargin < 5
    s_l = 0;
  end

  lags = p_l - s_l + l_in';
end