%
%   PRDOPCPI - Function to evaluate pre-doppler stap adapting once per CPI.
%
%       Invocation:      
%
%          prdopcpi( fname, fext, stride, load_dB, g )
%
%       Where:
%
%          fname:     Name of input file (.ts) and parameter file (.m)
%          fext:      Extension of output file (fname.fext)
%          stride:    Spacing between samples for training set
%          load_dB:   diagonal loading level (dB) relative to noise floor
%          g:         clutter-to-noise multiplier 
%

function prdopcpi(fname,fext,stride,load_dB,g)

eval([fname])
eval([ 'load ' fname '.ts -mat' ])


[ntot,nels]=size(C);
nsamp=ntot/npulse;

ndelays=3;			% Number of time degrees of freedom for STAP Processing
mode=0;				% STAP
theta=0;			% Look azimuth
asll=-35;			% Azimuth Sidelobe Level (dB)
dsll=-40;  			% Doppler Sidelobe level (dB) (1=binomial wts, 0=uniform)
load_lvl=10^(.05*(load_dB));	% Diagonal Loading Level (dB)
history=0;			% Accumulate Sample History from PRI to PRI over whole CPI

range=300;			% Target Range Cell(s)
az=0;				% Target Azimuth(s) (deg)
doppler=-.5:.01:.5;		% Target Doppler(s) (normalized)



%
% Generate target and assemble input data matrix xn
%

% T=gen_tgt( nsamp , npulse , nels , range , az , doppler(k) , snr );

x = g*C + N;	% Clutter + Target + Jammer + Noise

clear C J N

%
% Define training set(s) and application set(s)
%

t_set=1:stride:(npulse-ndelays+1)*nsamp;
app_set=1:(npulse-ndelays+1)*nsamp;

%
% STAP Processing
%

lambda0=c/(f0*1e6);
fc=2*v*cos(torad(w0))/lambda0/prf;

[out,w,s,e,el]=stap(x,npulse,ndelays,d,f0,mode,history,theta,asll,fc+.5,1,t_set,app_set,load_lvl,fc);

%
% Doppler Process STAP Output
%

nfft=npulse-ndelays+1;
out2=reshape(out, nsamp , nfft );
dwt=chebwgt(nfft,dsll);

for k = 1 : nsamp
   out3(k,:) = fft( conj( out2(k,:) ) .* dwt );
end

%
% Compute space-time pattern and responses of each doppler bin
% Multiply to form composite response for pre-doppler stap
%

P = pat_st( w(:,1), nels, d , f0 , -90:90 , doppler );
p = pat_st( w(:,1), nels, d , f0 , 0, doppler );

for k = 1 : length( doppler ) 
   Skn=exp( - j * 2*pi * doppler(k) * (0:nfft-1) ) ;
   pdop(k,:) = fft( dwt .* conj(Skn) );
   pat(k,:) = p(k) * pdop(k,:);
end

for k = 1 : nfft

    p_i_out(k)   = avpwr( out3( 1 : nsamp , k ) );
    p_i_in(k)    = avpwr( x(  1 : nsamp , 1 ) );
    int_suppr(k) = p_i_out(k) - p_i_in(k);
    sinr_imprv(:,k) = todb(abs(pat(:,k))) - int_suppr(k);
    sinr_max(k)  = 10*log10(nels*npulse) + p_i_in(k);
    sinr_loss(:,k) = sinr_max(k) - sinr_imprv(:,k);

end 

sinr_imprv0 = max( sinr_imprv' )';
sinr_loss0 =  max( -sinr_loss' )';

sinr_cum = flipud(sort( sinr_loss0(1:100) ));
u=find( sinr_cum >= -12 );
udsf = length(u);

[y,level]=sll_cum(P);

eval([ 'save '  fname  '.'  fext  ' p_i_in p_i_out int_suppr doppler sinr_imprv0 sinr_loss0  sinr_cum udsf w s e el y level' ]) 
