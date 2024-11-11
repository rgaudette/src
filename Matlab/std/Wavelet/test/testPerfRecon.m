% Examine the perfect reconstruction constraints of the DWT
%
%  - primarily some DWT/IDWT pairs return a sequence that is not the same
%    length as the original
%    * wavelet filter length
%    * boundary handling

signal = randn(1, 1023);
wavelet = 'sym8';
%     DWTMODE('sym') sets the DWT mode to symmetric-padding
%        (boundary value symmetric replication - default mode).
 
%     DWTMODE('zpd') sets the DWT mode to zero-padding
 
%     DWTMODE('spd') or DWTMODE('sp1') sets the DWT mode 
%        to smooth-padding of order 1 (first derivative
%        interpolation at the edges).
 
%     DWTMODE('sp0') sets the DWT mode to smooth-padding
%        of order 0 (constant extension at the edges). 
 
%     DWTMODE('ppd') sets the DWT mode to periodic-padding
%        (periodic extension at the edges).

%     DWTMODE('per') sets the DWT mode to periodization.
boundaryMode = 'per';
st=clock; [loDetail hiDetail] = wfilters(wavelet, 'd');etime(clock, st)
length(loDetail)
length(hiDetail)
[approx detail] = dwt(signal, wavelet, 'mode', boundaryMode);
recon = idwt(approx, detail, wavelet, 'mode', boundaryMode);

fprintf('%s %s %d: ', wavelet, boundaryMode, length(signal));
if length(recon) == length(signal)
  maxAbsDiff = max(abs(recon - signal));
  if maxAbsDiff < 1E-10
    fprintf('PR\n');
  else
    fprintf(' No PR %e\n', maxAbsDiff);
  end
else
  fprintf('diff length ');
  maxAbsDiffLocal = max(abs(recon(1:length(signal)) - signal));
  if maxAbsDiff < 1E-10
    fprintf('PR\n');
  else
    fprintf(' No PR %e\n', maxAbsDiff);
  end
end
