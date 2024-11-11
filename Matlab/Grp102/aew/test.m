[ntot,nels]=size(C);
nsamp=ntot/npulse;

ndelays=3;		% Number of time degrees of freedom for STAP Processing
mode=-1;		% Pre-Doppler STAP
theta=0;		% Look azimuth
asll=-30;		% Azimuth Sidelobe Level (dB)
dop=.20;		% Look Doppler (normalized)
dsll=-50;		% Doppler Sidelobe level (dB)
load_lvl=10^(.05*.01);	% Diagonal Loading Level (dB)
history=1;		% Accumulate Sample History from PRI to PRI over whole CPI

range=[300];		% Target Range Cell(s)
az=[0];			% Target Azimuth(s) (deg)
doppler=[.20];		% Target Doppler(s) (normalized)
snr=[55];		% Target Signal-to-Noise Ratio (dB)


%
% Generate target and assemble input data matrix xn
%

T=gen_tgt( nsamp , npulse , nels , range , az , doppler , snr );

x = C + T + N;	% Clutter + Target + Jammer + Noise

clear T
clear Z



%
% Define training set(s) and application set(s)
%

t_set=1:61:(npulse-ndelays+1)*nsamp;
app_set=1:(npulse-ndelays+1)*nsamp;

%
% STAP Processing
%
lambda0=c/(f0*1e6);
fc=2*v*cos(torad(w0))/lambda0/prf;

[out,w,s,e,el]=stap(x,npulse,ndelays,d,f0,mode,history,theta,asll,dop,dsll,t_set,app_set,load_lvl,fc);

pat_st( w(:,1), nels, d , f0 , (-90:90), (-.5:.01:.5), 1 , 'Space-Time Adapted Pattern', ' ');

for k=length(range)

   p_tgt(k)     = todb(abs(out(range(k))))
   p_i_out(k)   = avpwr( out( range(k)-9 : 2 : range(k)+9 ) )
   sinr_out(k)  = p_tgt(k) - p_i_out(k)
   p_i_in(k)    = avpwr( x(  range(k)-9 : 2 : range(k)+9 , 1 ) )
   sinr_in(k)   = snr(k) - 10*log10(nels*npulse) - p_i_in(k)
   sinr_imprv   = sinr_out(k) - sinr_in(k) 
   sinr_max(k)  = 10*log10(nels*npulse) + p_i_in(k)
   sinr_loss(k) = sinr_max - sinr_imprv

end 


figure(2)

r=.54*(Rmin:Rstep:Rmax);

plot( r, todb(abs([ x(1:nsamp,1) out ])) )

xlabel('Range (nmi)')
ylabel('dB')
title('SINR Improvement')

