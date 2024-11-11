function y=svf(angle,n,d,f,sll)
%       SVF - Compute steering vector at specified frequency
%
%		(Modified 4/27/93 to normalize steering vector to unit power)
%
%         Calling sequence:
%
%            y = svf( angle , n , d , f , sll )
%
%         Inputs:
%
%           angle = steering angle
%           n     = number of elements
%           d     = element spacing (m)
%           f     = frequency (MHz)
%           sll   = sidelobe level of Chebyshev taper, if specified.
%                   uniform taper if omitted.
%
%
lambda = 300 / f;
x=(1:n)-((n+1)/2);
theta=(pi/180.0)*angle;
if nargin==5
   taper = chebwgt(n,sll)';
else
   taper = (1/sqrt(n))*ones(n,1);
end
y = taper .* exp( j*2*pi*(d/lambda)*x'*sin(theta) );
