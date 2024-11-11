%
%	SIM_AEW - Space-Time Adaptive Processing (STAP) Environment Simulation 
%		  for Joint AEW Signal Processing Study Group.
%
%		  Program by K. Teitelbaum, MIT Lincoln Laboratory
%
%		  EMAIL:  kteitelbaum@ll.mit.edu
%		  PHONE:  (617) 981-2807
%
%
%		  Version 1.0  16 september 1993
% 

function sim_aew(fname)

%...................................................................................
% 			Program Initialization
%...................................................................................

fprintf(1,'\n%s ...\n\n',fname)

t0=clock;					% Start timer
op0=flops;					% Start operations count						% output


eval(fname)					% Execute parameter file (fname.m)

r = (Rmin:Rstep:Rmax)';				% Range to clutter cell (Km) 
nr=length(r);					% Number of range cells
	
az=(az_min:az_step:az_max)';			% Azimuth of clutter cells (degrees)
azr = torad(az);				% Azimuth of clutter cells (radians)
nt=length(az);					% Number of angle cells
						% ( az, azr are nt x 1 )

elr = asin((2*Re*h+h^2+r.^2)./(2*r*(Re+h)));	% Elevation of clutter cells (radians)
el =todeg(elr);					% Elevation of clutter cells (degrees)
						% ( el, elr are nr x 1 )

t1=h./r;					% calculate grazing angle at each clutter
t2=(1+h/(2*Re));				% cell (beta, nr x 1)
t3=r./(2*Re);
beta=asin(t1*t2-t3);				

index=find(beta<0);				% Below Horizon, set grazing angle to 0.
beta(index)=zeros( size(index) );


nj=length(jnr);					% Number of Jammers

nf=length(f);					% Number of Frequencies

dps = 360 * rpm * (1/60) ;			% rotation rate (degrees/second)
wstep_pri = dps * (1/prf);			% rotation angle between PRIs

if exist('ads18s')==1				% check to see if filename specified for ads-18s data
   use_ads18s=1;
else
   use_ads18s=0;
end

S1 = zeros(nr,nt);				% Pre-allocate storage

C = zeros(nr*npulse,nels);			% Pre-allocate storage
J = zeros(nr*npulse,nels);			% Pre-allocate storage

if nr==1
   S4 = zeros( nt , nels*npulse );		% Pre allocate storage
   U2 = zeros( nj , nels*npulse );		% Pre allocate storage
   Rj = zeros( nels*npulse );			% Pre allocate storage
   Rc = zeros( nels*npulse );			% Pre allocate storage
end



%...................................................................................
% 			Generate Amplitude Distribution
%...................................................................................

if s_mode == 0 

   S0 = (randn(nr,nt) + j*randn(nr,nt))/sqrt(2);	% Normal Scattering Field in polar
							% coordinates
elseif s_mode == 1

   S0 = ones(nr,nt);					% Unit Scattering Field in polar
							% coordinates
end

area = r*1000 * torad(az_step) * rcell; 	% area of scattering cell


cnr = alpha * area .* sin(beta) ./ (r*1000).^4;	% Compute clutter-to-noise ratio (power)
cnr_v = sqrt(cnr);				% 			         (voltage)
cnr_db = 10*log10(cnr);				%				 (power-dB)


for k = 1 : nt					% Weight field of random scatterers by cnr
   S1(:,k) = cnr_v .* S0(:,k);
end

%...................................................................................
% 			Generate Velocity Distribution
%...................................................................................


V_pm = v*cos(elr)*cos(azr)';			% platform motion

V_im = im_mean + im_sigma*randn(nr,nt);		% internal clutter motion

V = V_pm + V_im;				% V matrix now has radial velocity of each
						% scatterer


%...................................................................................
% 			Loop over Frequency
%...................................................................................

for fnum=1:nf

  if tx_taper==0				% Define transmit steering vector
    s_tx=svf(0,nels,d,f0);
  else
    s_tx=svf(0,nels,d,f0,tx_taper);			
  end


  if use_ads18s==1				% read in ads-18s element data if available
     ads_pat=read_ads(ads18s,f(fnum));
  end


  phi = 2*pi * (1/prf) * (2*V/lambda(fnum));	% PRI-to-PRI doppler phase shift


  %...................................................................................
  % 			Loop over PRIs   (Pulse Repetition Interval)
  %...................................................................................


  for pri=1:npulse


     fprintf(1,'Frequency = %i MHz  pri = %i \n',f(fnum),pri)


     ejphi = exp(-j*phi*(pri-1));		% Phase of scatterers this pri due to
			    			% Doppler Shift (nr x nt)
  

     w_tx = w0 + wstep_pri * (pri-1);		% Scan angle for transmit	


						% Compute transmit pattern (nr x nt)

     if use_ads18s==1
        g_tx = ones(nr,1) * upattern( s_tx, f(fnum), ads_pat, (az-w_tx), intrp ).';
     else
        g_tx = tpattern( s_tx, (az-w_tx), el, d, f(fnum), lc );	
     end


     S2 = S1 .* ejphi .* abs(g_tx);		% Multiply Scattering matrix by transmit gain
						% and Doppler shift


     w_rx = w_tx + dps*r/.15e6;			% scan angle vs range gate (nr x 1)

     az2 = ones(nr,1)*az' - w_rx*ones(1,nt);	% angle(deg) on receive of each scatterer in
						% antenna reference frame (nr x nt )
    
     if use_ads18s==1				% if working with ads-18s data,
       i1 = find(az2>=180);			% map angles into [-180,180] so
       az2(i1) = az2(i1) - 360;			% that we won't confuse the
       i2 = find(az2<=-180);			% interpolation routines
       az2(i2) = az2(i2) + 360;
     end

     if use_ads18s==0				% if ads18s patterns are not provided,
 						
       g_rx = el_pat(az2,lc);			%  calculate rx element patterns using the function el_pat


						% now compute the rx element patterns for the jammers 
        for k = 1 : nj
          g_rx_jam(:,k) = el_pat( jam_az(k) - w_rx  , lc );	
        end

     end						





     ampl=10.^(.05*jnr);

     if nr > 1
        z=(randn(nr,nj) + j*randn(nr,nj))/sqrt(2);	% Jammer Waveform(s)
        jam = (ones(nr,1)*ampl)  .*  z;
     elseif nr == 1
        jam = ampl;
     end


     %...................................................................................
     % 			Loop over antenna element
     %...................................................................................




     for element = 1 : nels

    

        %------------------------------------------------------%
	% Let's do the clutter contribution first...           %
	%------------------------------------------------------%


        n = element - (nels+1)/2;			% element number

        el2=el*ones(1,nt);				% elevation of each scatterer
        sc =  sin(torad(az2)) .* cos(torad(el2));	% sin(az)*cos(el) for each scatterer
        p_c = -2*pi*n*(d/lambda(fnum))*sc;		% path delay phase shift for each scatterer	
  

	if use_ads18s==1				% if ads-18s data is available, interpolate
	   g_rx=zeros(nr,nt);				% to azimuths of scattering cells on rx (az2)
	   x0=-180:180;					% to get g_rx
	   y0=ads_pat(:,element);
	   g_rx(:) = interp1(x0,y0,az2(:),intrp);
        end



        S3 = S2 .* g_rx .* exp(j*p_c);	  		% weight scattering matrix - now has
							% right IQ for each scatterer for
							% this pri and element.


	%------------------------------------------------------%
	% Now for the jamming contribution...                  %
	%------------------------------------------------------%


        for k = 1 : nj					
           p_j(:,k) = -2*pi*n*(d/lambda(fnum))*sin(torad(jam_az(k)-w_rx));
        end  

 
	if use_ads18s==1				% if ads-18s data is available, interpolate			
	   for k = 1 : nj				% to azimuths of jammers on rx 

	     x1 = jam_az(k) - w_rx; 			% jammer az in antenna reference frame

             i1 = find(x1>=180);			% map angles into [-180,180] so 
             x1(i1) = x1(i1) - 360;			% that we won't confuse the interpolation
             i2 = find(x1<=-180);			% routine
             x1(i2) = x1(i2) + 360;

	     g_rx_jam(:,k) = interp1(x0,y0,x1,intrp);

           end
        end

  
       U = jam .* g_rx_jam .* exp(j*p_j);


	%------------------------------------------------------%
	% Accumulate data for multiple pris and elements       %
	%------------------------------------------------------%
 

        if nr==1						

	  index = (pri-1)*nels + element;		% if only one range cell, we will
	  S4(:,index) = S3.';				% want to save scattering data in
							% S4 so thatwe can compute ideal
       							% covariance matrix


	  U2(:,index) = U.';				% Do the same for the jamming
	

        else

	  n1=(pri-1)*nr+1;				% Otherwise, we will want to
	  n2=pri*nr;					% sum over all azimuths to get time
							% series data


	  C(n1:n2,element) = C(n1:n2,element) + sum( S3.' ).';		
	  J(n1:n2,element) = J(n1:n2,element) + sum( U.' ).';        
							
        end
     					
     end

     %.......................................................................................
     % End loop over elements
     %.......................................................................................

 
  end

  %.......................................................................................
  % End loop over pri
  %.......................................................................................


  if nr==1
     Rc = Rc + S4'*S4;					% compute clutter covariance matrix
     Rj = Rj + blkcov(U2,npulse);			% compute jammer covariance matrix
  end

end


%.......................................................................................
% End loop over frequency, Output Resluts
%.......................................................................................


if nr==1						% if ideal cov. mode (1 rg)

   Rc = (1/nf)*Rc;					
   Rj = (1/nf)*Rj;
   Rn = eye(size(Rc));					% compute noise covariance matrix

   eval([ 'save ' fname '.cov Rc Rj Rn' ])		% Save output in file (fname.mat)

else

   C = (1/nf) * C;
   J = (1/nf) * J;
   N = (randn(size(C)) + j*randn(size(C)))/sqrt(2);
   eval([ 'save ' fname '.ts C J N' ])			% Save output in file (fname.mat)

end

 deltaT=etime(clock,t0);				% Program Execution Time (s)
 meg_ops=(flops-op0)/1000000;				% Operations Count
 mflops = meg_ops/deltaT;				% Millions of FLt. pt. Ops Per Sec


fprintf(1,'\n\n\nProgram Execution Time (seconds):   %f \n',deltaT)
fprintf(1,'Operations Count (millions):  %f \n', meg_ops )
fprintf(1,'Computation Rate (MFLOPS):   %f \n\n', mflops )
