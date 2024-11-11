%frc            Fourier ring correlation
%
%   cc = frc(im1, im2, rings)
%
%   cc           The 
%
%   parm        Input description [units: MKS]
%
%   Optional    OPTIONAL: This parameter is optional (default: value)
%
%
%   TEMPLATE Describe function, it's methods and results.
%
%   Calls: none
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2004/01/21 00:49:32 $
%
%  $Revision: 1.1 $
%
%  $Log: frc.m,v $
%  Revision 1.1  2004/01/21 00:49:32  rickg
%  Initial revision
%
%  Revision 1.1.1.1  2004/01/03 08:23:56  rickg
%  Matlab Source
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function cc = frc(im1, im2, rings)

% Check to see if the images are the same size
[nyIM1 nxIM1] = size(im1);

% Find the frequency magnitude for each sample
fx = fftshift([0:nxIM1-1]/nxIM1);
negFreq = (fx >= 0.5);
fx(negFreq) = fx(negFreq) - 1;

fy = fftshift([0:nyIM1-1]/nyIM1)';
negFreq = (fy >= 0.5);
fy(negFreq) = fy(negFreq) - 1;

[FY FX] = ndgrid(fy, fx);
freq = sqrt(FX.^2 + FY.^2);

% Compute the FFT of each image
IM1 = fftshift(fft2(im1));
IM2 = fftshift(fft2(im2));
% Compute the correlation coefficient for each ring
nRings = length(rings)-1;
for iRing = 1:nRings
  idxRing = find((freq >= rings(iRing)) & (freq < rings(iRing+1)));
  idxRing = idxRing(:);
  ring1 = IM1(idxRing);
  ring2 = IM2(idxRing);
  IM1SqSum = sum(abs(ring1) .^2);
  IM2SqSum = sum(abs(ring2) .^2);
  cc(iRing) =  (ring1' * ring2) / sqrt(IM1SqSum .* IM2SqSum);
end

