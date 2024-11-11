function y=spattern(w,p,d,f)
%
%     SPATTERN - Compute pattern of a beam assuming half-wavelength
%               spacing.  If no output arguments are specified, the
%               computed pattern will be plotted.  Cut off plot at
%               -100 dB.  If element spacing and frequency are omitted,
%	        half-wavelength spacing will be assumed.
%
%               Calling sequence:
%
%                    y = spattern(w,p,d,f)
%
%               Inputs:
%
%                    w:    weight vector
%                    p:    vector of angles at which to compute pattern (deg)
%		     d:	   element spacing (m)  (OPTIONAL)
%		     f:    frequency (MHz) (OPTIONAL)
%
%               Outputs:
%
%                    y:    computed pattern (complex)
%

[n,k]=size(w);					% get size of input argument:
						%     n = number of elements
						%     k = number of weight vectors

if nargin==4
  lambda=299.7925/f;				% compute wavelength (m) from frequency (MHz)
end

phi=torad(p);					% convert degrees to radians

N=(1:n)-((n+1)/2);				% number element positions

if nargin==2					% compute pattern
  Z=exp(-j*pi*(sin(phi)'*N) );
else
  Z=exp(-j*2*pi*(d/lambda)*(sin(phi)'*N) );	
end

y=(Z*w);

if nargout==0					% plot patterns if no output arguments
  yy=todb(abs(y)+.00001);
  plot(p,yy)
  xlabel('ANGLE (deg)')
  ylabel('GAIN (dB)')
end
