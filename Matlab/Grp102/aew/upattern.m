function z=pattern(w,f,e,theta,intrp)
%
%     UPATTERN - Compute pattern for ADS-18S Antenna
%
%
%               Calling sequence:
%
%                    z = upattern(w,f,e,theta,intrp)
%
%               Inputs:
%
%                    w:   weight vector
%		     f:   desired frequency
%		     e:   element patterns
%		 theta:   vector of azimuths at which to interpolate pattern (OPTIONAL)
%			  (azimuths are in degrees and must be within the 
%			   interval [-540,540] )
%	   	 intrp:   interpolation method:
%			    'linear'
%			    'spline'
%			    'cubic'	
%		    
%               Outputs:
%
%                    z:   computed pattern for array
%
%


d = 299.7925/426/2;			% element spacing for ADS-18S
lambda = 299.7925/f;

n=length(w);				% number of elements (18)

p=(-180:180);
phi=(pi/180.)*p;

x=(1:n)-((n+1)/2);
Z=exp(-j*2*pi*(d/lambda)*sin(phi)'*x );
y=abs(Z.*e*w);

%
%  interpolation
%

if nargin==4

   temp = theta;

   i1 = find(temp>=180);
   temp(i1) = temp(i1) - 360;

   i2 = find(temp<=-180);
   temp(i2) = temp(i2) + 360;

   z = interp1( p , y , temp , intrp );
   x = theta;

else

   z = y;
   x = p;

end




if nargout==0
  zz=todb(z+.00001);
  plot(x,zz)
  xlabel('ANGLE (deg)')
  ylabel('GAIN (dB)')
end
