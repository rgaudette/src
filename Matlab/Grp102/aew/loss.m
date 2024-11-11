function y=loss(Rinv,nels,ndelays,thet,asll,dop,dsll,d,f)
%
%  compute and plot sinr loss.
% 
%  y=loss(Rinv,nels,ndelays,thet,asll,dop,dsll,d,f)
%
% Rinv = inverse of the covariance matrix
% nels = number of elements
% ndelays = number of delays
% thet = azimuth (deg)
% asll = azimuth sidelobe level
%        ( 0 = no weighting )
% dop = row vector of doppler frequencies
% dsll = doppler sidelobe level (Chebyshev weighting)
%        ( 0 = no weighting)
%        ( 1 = binomial weighting)
% d = element spacing (m)
% f = frequency (MHz)
% tap = number of dB down in taper


y=zeros(length(dop),1);                              % dimension the output

for k=1:length(dop)
 s=sv_stap(nels,ndelays,thet,asll,dop(k),dsll,d,f);  % steering vector
 hol=pat_st(Rinv*s,nels,d,f,thet,dop(k));
 sinr=real(hol.*conj(hol)/(s'*Rinv*s));              % signal-to-interference-plus-noise
 y(k)=10.*log10(sinr/(nels*ndelays));                % sinr loss (dB)
end

if nargout==0                                        % if no output argument, then plot sinr loss
 plot(dop,y)
 xlabel('dop frequencies (MHz)')
 ylabel('sinr loss (dB)')
 grid
end
