%
%     [out,w,s,e,el]=stap(x,npulse,ndelays,d,f,mode,history,theta,asll,dop,dsll,t_set,app_set,load_lvl,fc)
%
%     inputs:
%
%	x = 		input data set ( nsamp*npulse by nels )
%	npulse = 	number of pulses (PRIs) in input data set
%	ndelays =	number of time degrees of freedom for stap processing
%	d = 		array element spacing (m)
%	f = 		Frequency (MHz)
%	mode =		-1 (pre-doppler stap)
%	      		 0 (stap)
%              		 1 (post-doppler stap)
%       history = 	sample history control:
%                       0 (no history)
%			1 (accumulate sample history over all training sets)
%       theta =		look azimuth (deg)
%	asll =		azimuth sidelobe level (dB) (Chebyshev taper)
%	dop = 		look doppler (normalized)
%	dsll = 		doppler sidelobe level (dB) (Chebyshev taper)
%                       ( 0 = no weighting )
% 			( 1 = binomial weights )
%	t_set = 	table of range cells to include in training set
%	app_set = 	table of range cells over which to apply weights
%	load_lvl = 	diagonal loading level (dB)
%	fc = 		normalized doppler of mainlobe clutter (OPTIONAL)
%			(if specified, notch of binomial canceller is placed
%			 at ml clutter doppler.  Otherwise, it is placed at the
%			 doppler specified by dop.)
%     
%     outputs:
%	
%	out = 		output data
%	w = 		weight vector
%	s = 		steering vector
%       ------OPTIONAL----------------------------------------------------
%	e = 		eigenvalues of sample covariance matrix (dB)
%	el = 		eigenvalues of loaded sample covariance matrix (dB)	
%



function [out,w,s,e,el]=stap(x,npulse,ndelays,d,f,mode,history,theta,asll,dop,dsll,t_set,app_set,load_lvl,fc)

[ntot,nels]=size(x);
nsamp=ntot/npulse;


%.....Generate PRI delays


for k=1:ndelays
  y(:,(k-1)*nels+1:k*nels) = x( ((k-1)*nsamp+1):(npulse-(ndelays-k))*nsamp , : );
end

%.....Doppler Filter

if mode==1

   eta=2*pi*dop;

   wgt=chebwgt(npulse-ndelays+1,dsll);

   yd=zeros(nsamp,ndelays*nels);

   for k=1:npulse-ndelays+1
      yd = yd + wgt(k)*y((k-1)*nsamp+1:k*nsamp,:)*exp(j*eta*(k-1));
   end

else

   yd=y;

end


%
%....Loop over all training sets / application regions
%

[nsets,nsamples]=size(t_set);

for set = 1 : nsets

   set

   %
   %....Generate sample matrix and compute eigenvalues/eigenvectors
   %

   indx=find( t_set(set,:) > 0 );
   u = t_set(set,indx);
   ns=length(u);			% number of samples in this training set

   if ( history==0 | set==1 )
     M = yd(u,:)/sqrt(ns);
   else
     M = [ yd(u,:)/sqrt(ns) ; R ];
   end

   N=ndelays*nels;
   Ml = [ M' load_lvl*eye(N) ]';

   if nargout==5
       e(:,set)=flipud(sort( 10*log10(abs(eig(M'*M))) ));
      el(:,set)=flipud(sort( 10*log10(abs(eig(Ml'*Ml))) ));
   end

   %
   %....Compute steering vector
   %

   if mode==0

      s=sv_stap(nels,ndelays,theta,asll,dop,dsll,d,f);

   else

      if nargin==15
         eta=fc+.5;
      else
         eta=dop;
      end

      s=sv_stap(nels,ndelays,theta,asll,eta,1,d,f);

   end

   %
   %....Compute Adapted weights 
   %

   [Q R]=qr(Ml);
   R=R(1:N,:);

   v=R'\s;
   w(:,set)=R\v;

   w(:,set)=w(:,set)/sum(abs(w(:,set)));

   %
   %....Beamform
   %

   u=app_set(set,:);
   bf(u,1)=yd(u,:)*w(:,set);

end


%.....Doppler Filter

if mode==-1

   eta=2*pi*dop;

   wgt=chebwgt(npulse-ndelays+1,dsll);

   out=zeros(nsamp,1);

   for k=1:npulse-ndelays+1
      out = out + wgt(k)*bf((k-1)*nsamp+1:k*nsamp,:)*exp(j*eta*(k-1));
   end

else

   out=bf;

end
