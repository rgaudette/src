function [peakRotCCC] = alignSingleTest(reference, particle, ...
                                        vecPhi, vecTheta, vecPsi, ...
                                        searchRadius, lowCutoff, hiCutoff, ...
                                        rngTilt);

flgDebugGraphics = 0;
flgDebugText = 2;

if nargin < 6
  searchRadius = [10 10 10];
else
  if length(srchRadius) == 1
    searchRadius = [1 1 1] * searchRadius;
  end
end

if nargin < 7
  lowCutoff = 0;
end

if nargin < 8
  hiCutoff = 0.866;
end

if nargin < 9
  rngTilt = [-60 60];
end

szRef = size(reference);
posCenter = floor(szRef / 2) + 1;

%
% Construct the correlation search radius mask
% ASSUME reference and test volumes are the same size as is the resulting
% cross correlation function
%
imageMask = ones(szRef);
imageMask([1:searchRadius(1) end-searchRadius(1)+1:end], :, :) = 0;
imageMask(:, [1:searchRadius(2) end-searchRadius(2)+1:end], :) = 0;
imageMask(:, :, [1:searchRadius(3) end-searchRadius(3)+1:end]) = 0;
xcfMask = zeros(szRef);
xcfMask([posCenter(1)-searchRadius(1)+1:posCenter(1)+searchRadius(1)-1], ...
        [posCenter(2)-searchRadius(2)+1:posCenter(2)+searchRadius(2)-1], ...
        [posCenter(3)-searchRadius(3)+1:posCenter(3)+searchRadius(3)-1]) = 1;

%
% Create the frequency domain filter if requested
%
if lowCutoff > 0 | hiCutoff < 0.866 
  flgFreqFilt = 1;
  fltBandpass = ones(szRef);

  % High pass filter
  if lowCutoff > 0
    if length(lowCutoff) < 2
      transWidth = 0.1;
    else
      transWidth = lowCutoff(2);
    end
    nRadius = szRef(1) * lowCutoff(1);
    nTrans = szRef(1) * transWidth;
    fltBandpass = my_spheremask(fltBandpass, nRadius, nTrans, [], 1);
  end

  % Low pass filter
  if hiCutoff < 0.866
    if length(hiCutoff) < 2
      transWidth = 0.1;
    else
      transWidth = hiCutoff(2);
    end
    nRadius = szRef(1) * hiCutoff(1);
    nTrans = szRef(1) * transWidth;
    fltBandpass = my_spheremask(fltBandpass, nRadius, nTrans);
  end
else
  flgFreqFilt = 0;
end

%
% Create the missing wedge frequency domain weighting
%
wWedge = av3_wedge(ones(szRef), rngTilt(1), rngTilt(2));


% Frequency domain filter the particle if required
fParticle = fftshift(fftn(particle));
if flgFreqFilt
  fParticle = fParticle .* fltBandpass;
end
    
% Zero out any DC in the particle
fParticle = ifftshift(fParticle);
fParticle(1, 1, 1) = 0;

if flgDebugGraphics
  figure(1)
  tom_dspcub(real(ifftn(fParticle)));
  title('Filtered Particle');
end
    
% Compute the energy scaling due to the masked region of the particle
nrgParticleMap = real(...
  ifftn(fftn(ifftn(fParticle) .^ 2) .* conj(fftn(imageMask))));

if flgDebugGraphics
  figure(1)
  tom_dspcub(nrgParticleMap);
  title('Particle Scaling Map');
end

% FIXME implement offset later
centerRotation = [0 0 0];

iRotation = 0;
peakCCC = -1;
% Loop over the Euler angles
for delPhi = vecPhi
  for delTheta = vecTheta
    for delPsi = vecPsi
      iRotation = 1;
      
      delRotate = [delPhi delTheta delPsi] * pi / 180;
      totalRotation = eulerRotateSum(centerRotation, delRotate);
      phi = totalRotation(1) * 180 / pi;
      theta = totalRotation(2) * 180 / pi;
      psi = totalRotation(3) * 180 / pi;

      % Rotate the reference particle
      rotRef = tom_rotate(reference, [phi psi theta]);

      % Remove the mean value
      rotRef = rotRef - mean(rotRef(:));
          
      % Correlation shift range masking
      % DO NOT DO ANYTHING TO CHANGE THE DC VALUE AFTER THIS
      % The imageMask provides correlation anti-aliasing protection
      rotRef = rotRef .* imageMask;

      % Bandpass filter the reference particle
      fReference = fftshift(fftn(rotRef));
      if flgFreqFilt
        fReference = fReference .* fltBandpass;
      end

      % Weight the frequency domain reference to handle the missing wedge
      % FIXME: is this really correct?
      fReference = fReference .* wWedge;

      % Zero out any DC in the reference
      fReference = ifftshift(fReference);

      % Compute the energy in the modified reference 
      nrgReference = sum(fReference(:) .* conj(fReference(:))) ...
          ./ prod(size(fReference));

      % Compute the cross-correlation coefficient function
      CCC = real(ifftn(fParticle .* conj(fReference))) ...
            ./ sqrt(nrgParticleMap .* nrgReference);

      % Quadrant shift to mask and find the cross correlation coeficient
      % peak 
      CCC = fftshift(CCC) .* xcfMask;

      % Find the peak cross-correlation coefficient
      % DO NOT use peak_det_2 for this since it interpolates the
      % coefficient too high on 
      [maxCCC indices] = arraymax(CCC);
      if nargout > 0
        peakParams(iRotation, 1) = maxCCC;
        peakParams(iRotation, 2) = phi;
        peakParams(iRotation, 3) = theta;
        peakParams(iRotation, 4) = psi;
        peakParams(iRotation, 5:7) = indices - posCenter;
      end

      if flgDebugText > 1
        fprintf('phi: %6.2f  theta: %6.2f  psi: %6.2f', ...
                phi, theta, psi)
        fprintf('  peak CCC %f @ indices %6.2f %6.2f %6.2f\n', ...
                maxCCC, indices(1), indices(2), indices(3))
      end
          
      if maxCCC > peakCCC
        peakRotCCC = CCC;
        peakCCC = maxCCC;
        peakPhi = phi;
        peakTheta = theta;
        peakPsi = psi;
        peakIndex = indices;
            
        % Use peak_det_2 to find fractional pixel shift
        % FIXME replace this !!!
        [pos interpCCCC] = peak_det_2(CCC)
        tshift = pos - posCenter
      end
      
    end
  end
end
