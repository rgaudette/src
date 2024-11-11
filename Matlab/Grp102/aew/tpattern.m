function y=spattern(w,p,el,d,f,elpat)
%
%     TPATTERN - Compute pattern of a beam for specified elevation cuts.
%                If no output arguments are specified, the
%                computed pattern will be plotted.  Cut off plot at
%                -100 dB.  If element spacing and frequency are omitted,
%	         half-wavelength spacing will be assumed.
%
%               Calling sequence:
%
%                    y = spattern(w,p,el,d,f,elpat)
%
%               Inputs:
%
%                    w:    weight vector
%                    p:    vector of angles at which to compute pattern (deg)
%		    el:    vector of elevation cuts for pattern (deg)
%		     d:	   element spacing (m)  (OPTIONAL)
%		     f:    frequency (MHz) (OPTIONAL)
% 	         elpat:    element pattern (OPTIONAL)
%			     none - omnidirectional
%			     0    - cosine
%			     1    - cardioid
%			    >1    - limacon (produces array backlobe)
%
%               Outputs:
%
%                    y:    computed pattern (complex)
%

[n,k]=size(w);					% get size of input argument:
						%     n = number of elements
						%     k = number of weight vectors

if nargin>=5
  lambda=299.7925/f;				% compute wavelength (m) from frequency (MHz)
end

phi=torad(p(:));				% convert degrees to radians, put in column vector format
theta=torad(el(:));
ncuts=length(theta);

N=(1:n)-((n+1)/2);				% number element positions

if nargin==6					% generate element pattern, normalized to unity gain
  el_pat = nmlze( cos(phi) + elpat );
else
  el_pat = ones( size(phi) );
end


for k = 1 : ncuts

  if nargin==3			
    Z=exp(-j*pi*cos(theta(k))*sin(phi)*N );
  else
    Z=exp(-j*2*pi*(d/lambda)*cos(theta(k))*sin(phi)*N );	
  end

  cut = el_pat .* (Z*w);

  y(k,:) = cut.';

end

if nargout==0					% plot patterns if no output arguments
  yy=todb(abs(y)+.00001);
  plot(p,yy')
  xlabel('ANGLE (deg)')
  ylabel('GAIN (dB)')
end
