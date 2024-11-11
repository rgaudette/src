%csplinecoef    Compute the cubic B-spline coefficients for the given signal
%
%   c = csplinecoeff(s, epsilon)
%
%   c           The cubic B-spline coefficients
%
%   s           The sequence to be modeled
%
%   epsilon     OPTIONAL: The required precision (default: eps)
%
%
%   csplinecoef computes the cubic B-spline coefficients of the signal 
%   represented by the sequence s.  The sequence is assumed be sampled
%   at integer values starting at zero.
%
%   Calls: none
%
%   Bugs: none known
%
%   Reference: Unser, Michael,  IEEE Signal Processing Magazine, Nov. 1999
%              pg 22-38


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/05 19:59:23 $
%
%  $Revision: 1.2 $
%
%  $Log: csplinecoeff.m,v $
%  Revision 1.2  2004/01/05 19:59:23  rickg
%  The coefficient vector matches the row/column nature of s.
%
%  Revision 1.1  2004/01/03 18:14:54  rickg
%  Initial revision
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function c = csplinecoeff(s, epsilon)

if nargin < 2
  epsilon = eps;
end

nSa = length(s);
c = zeros(nSa, 1);
cplus = zeros(size(s));
cminus = zeros(size(s));

% Compute the initial causal coefficient
alpha = sqrt(3) - 2;
kmax = min(ceil(log(epsilon) / log(abs(alpha))), nSa);
alphaCumProd = 1;
for k = 1:kmax
  cplus(1) = s(k) * alphaCumProd;
  alphaCumProd = alphaCumProd * alpha;
end

% Compute the causal coefficient sequence 
for k = 2:nSa
  cplus(k) = s(k) + alpha * cplus(k-1);
end

% Compute the initial anti-causal coefficient
cminus(nSa) = alpha / (1 - alpha^2) * (cplus(nSa) + alpha * cplus(nSa-1));

% Compute the anti-causal coeffcient sequence
for k = nSa-1:-1:1
  cminus(k) = alpha * (cminus(k+1) - cplus(k));
end

c = 6 * cminus;
