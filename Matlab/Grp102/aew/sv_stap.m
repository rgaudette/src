%
%     s=sv_stap(nels,ndelays,theta,asll,dop,dsll,d,f)
%
%     inputs:
%
%	nels = 		number of antenna elements
%	ndelays =	number of time degrees of freedom for stap processing
%       theta =		look azimuth (deg)
%	asll =		azimuth sidelobe level (dB) (Chebyshev taper)
%			( 0 = no weighting )
%	dop = 		look doppler (normalized)
%	dsll = 		doppler sidelobe level (dB) (Chebyshev taper)
%                       ( 0 = no weighting )
%			( 1 = binomial weights )
%	d = 		element spacing (m)
%	f = 		frequency (MHz)
%     
%     outputs:
%	
%	s = 		steering vector
%



function s=sv_stap(nels,ndelays,theta,asll,dop,dsll,d,f)


   %
   %....Compute steering vector
   %

   if asll == 0
     q= svf(theta,nels,d,f);			% Compute "Space" steering vector
   else
     q= svf(theta,nels,d,f,asll);
   end

   if dsll == 0					% Compute Doppler Weighting
     m = ones(1,ndelays);
   elseif dsll==1
     m=abs(mti(ndelays));				
   else
     m=chebwgt(ndelays,dsll);
   end

   k=(1:ndelays);				% Compute "Time"  steering vector
   v = m .* exp( j*2*pi*(k-1)*(dop+0) );

   s=kron(v.',q);				% Form "Space-Time" steering vector	

   s = s/sum(abs(s));				% Normalize to unity gain

 