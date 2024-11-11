function el_pat=read_ads(fname,f)
%
%     READ_ADS - Read in ADS-18S Antenna element pattern data
%		 and strip off exp[j2pi(d/lambda)sin(theta)]
%
%
%               Calling sequence:
%
%                    el_pat = read_ads(fname,f)
%
%               Inputs:
%
%                fname:   name of file containing multi-frequency ads-18s data
%			  ( path\filename.ext )
%		     f:   frequency to extract
%		    
%               Outputs:
%
%               el_pat:  element pattern matrix (361 x 18)
%

eval([ 'load ' fname ' -mat' ])		% get ads-18s element data
ff=421:.5:431;				% measurement frequencies
index=find(ff==f);			% find index to desired frequency
e=get_sm(Rpat,1,index,1,21);		% extract element patterns for desired
					% frequency
e(361,:)=e(1,:);			% make -180:180
d = 299.7925/426/2;			% element spacing for ADS-18S
lambda = 299.7925/f;
n=18;					% number of elements

p=(-180:180);				% azimuths of data points
phi=torad(p);				% convert to radians
x=(1:n)-((n+1)/2);			% number elements
Z=exp(-j*2*pi*(d/lambda)*sin(phi)'*x ); % compute correction term ( exp[j2pi....] )
el_pat=conj(Z.*e);			% element pattern data
