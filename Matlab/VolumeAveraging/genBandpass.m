%genBandpass    Compute bandpass frequency domain filter function
%
%  fltBandpass = genBandpass(szArray, lowCutoff, hiCutoff)
%
%  fltBandpass The frequency domain response of the requested bandpass
%              filter.
%
%  szArray     The size (in the frequency domain) of the array to be
%              filtered.
%
%  lowCutoff   The start of the low frequency roll-off and optionally the
%              transition width [fLow transwidth].  If the transition width
%              is not specified the default is 0.1.  If fLow <=0 then no
%              high pass function is implemented.
%
%  hiCutoff    The start of the high frequency roll-off and optionally the
%              transition width [fHigh transwidth].  If the transition width
%              is not specified the default is 0.1.  If fHigh >=0.866 then no
%              high pass function is implemented.
%
%  Bugs: hiCutoff limit appropriate only for 3D arrays
%        not correct for non-cubic volumes

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/08/15 23:17:36 $
%
%  $Revision: 1.5 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function fltBandpass = genBandpass(szVol, lowCutoff, hiCutoff)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: genBandpass.m,v 1.5 2005/08/15 23:17:36 rickg Exp $\n');
end

idxOrigin = floor(szVol/2) + 1;

% High pass filter
if lowCutoff > 0
  if length(lowCutoff) < 2
    transWidth = 0.1;
  else
    transWidth = lowCutoff(2);
  end
  nRadius = szVol(1) * lowCutoff(1);
  nTrans = szVol(1) * transWidth;
  fltBandpass = gaussianMask(szVol, nRadius, nTrans, idxOrigin, 1);
else
  fltBandpass = ones(szVol);
end

% Low pass filter
if hiCutoff < 0.866
  if length(hiCutoff) < 2
    transWidth = 0.1;
  else
    transWidth = hiCutoff(2);
  end
  nRadius = szVol(1) * hiCutoff(1);
  nTrans = szVol(1) * transWidth;
  fltBandpass = gaussianMask(szVol, nRadius, nTrans, idxOrigin) .* fltBandpass;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Log: genBandpass.m,v $
%  Revision 1.5  2005/08/15 23:17:36  rickg
%  Type fix
%
%  Revision 1.4  2005/08/15 22:55:50  rickg
%  Added global print ID
%
%  Revision 1.3  2005/02/18 23:49:21  rickg
%  Explicit orgin specification to match fftshift.
%
%  Revision 1.2  2004/10/26 17:03:56  rickg
%  Updated help
%  Uses gaussianMask
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%