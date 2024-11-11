%eulerCCSSearch Search the rotation and shift space for the highest LCCS
%
%   [peakLCCS, peakRotation, peakShift, matLCCS] = eulerCCSSearch( ...
%     fixedVol, rotateVol, eulerOffset, eulerSearch, maskCenter, ...
%     searchRadius, interpMethod, flgDebugText)
%
%   peakLCCS    The peak local correlation coefficient sequence (LCCS) value
%
%   peakRotation  The euler rotation of the peak LCCS value.
%
%   peak        The translation shift of the peak LCCS value.
%
%   matLCCS     The maximum LCCS value for each euler rotation parameter
%
%   fixedVol    The volume to be used as the reference for the search.
%
%   rotateVol   The volume to be rotated the LCCS searched.
%
%   eulerOffset The initial rotation applied to rotateVol.
%
%   eulerSearch The euler rotation parameters to be applied to rotateVol after
%               the eulerOffset.  This is a structure with the fields: Phi,
%               Theta, and Psi that are vectors of the values to be searched.
%
%   maskCenter  The center of the mask to be applied to the reference volume.
%               This also affect the calculation of the range of shifts, a [ ]
%               vector specifies the center of the volume.
%
%   searchRadius  The search radius for the translation shift [rx ry rz] which
%               also affects the mask size applied to the reference volume.  The
%               mask is in each dimension is szVol - 2 * searchRadius.
%
%   interpMethod  OPTIONAL: The interpolation method to use for the volume
%               rotation operation (default [ ] => 'linear').
%
%   flgVerbose  OPTIONAL: Print out intermediate results (default: 0).
%
%   Bugs: none known

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/08/15 23:17:36 $
%
%  $Revision: 1.8 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [peakLCCS, peakRotation, peakShift, matLCCS] = eulerCCSSearch( ...
  fixedVol, rotateVol, eulerOffset, eulerSearch, maskCenter, ...
  searchRadius, interpMethod, flgVerbose)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: eulerCCSSearch.m,v 1.8 2005/08/15 23:17:36 rickg Exp $\n');
end

st=clock;

if nargin < 7
  interpMethod = [ ];
end

if nargin < 8
  flgVerbose = 0;
end

% Compute the mask and support
szFixed = size(fixedVol);
idxOrigin = floor(szFixed/2) + 1;
mask = zeros(szFixed, 'single');
if ~ isempty(maskCenter)
  centerOffset = maskCenter - idxOrigin;
else
  centerOffset = [0 0 0];
end

  
lMin = 1 + searchRadius + centerOffset;
lMin = max([lMin; 1 1 1]);
lMax = szFixed - searchRadius + centerOffset;
lMax = min([lMax; szFixed]);
mask(lMin(1):lMax(1), lMin(2):lMax(2), lMin(3):lMax(3)) = 1;
if flgVerbose > 2
  lMin
  lMax
end

%  FIXME: mask should be implemented with a circular shift but this will break
%  p_l and p_h in lccs if it wraps.
% if ~ isempty(maskCenter)
%   centerOffset = maskCenter - floor(szFixed/2) + 1
%   mask = circshift(mask, centerOffset);
% end

% Compute the fourier transform of the masked fixed volume
maskedFixed = fixedVol .* mask;
if flgVerbose > 3
  fprintf('Writing out masked fixed volume\n');
  junk = save(MRCImage(maskedFixed), 'maskedFixed.mrc');
  clear junk
end
FIXED = fftn(maskedFixed);
clear mask maskedFixed 

peakLCCS = -1;
idxPhi = 1;
for delPhi = eulerSearch.Phi
  strIDPhi = sprintf('_%02d', idxPhi);

  idxTheta = 1;
  for delTheta = eulerSearch.Theta
    strIDTheta = sprintf('_%02d', idxTheta);

    idxPsi = 1;
    for delPsi = eulerSearch.Psi
      strIDPsi = sprintf('_%02d', idxPsi);
      % Find the total rotation required converting the offset into radians
      delRotate = [delPhi delTheta delPsi];
      totalRotation = eulerRotateSum(eulerOffset, delRotate);
        
      % Rotate the particle of interest, any extraplotion points are set to
      % zero which is the global mean
      rotPOI = ...
        volumeRotate(rotateVol, totalRotation, idxOrigin, interpMethod, 0);
      
      [lCCS lr lc lp] = lccs(FIXED, rotPOI, lMin, lMax);
      %%% Find the maximum correlation coefficient value and its position
      [maxLCCS idxMaxLCCS] = arraymax(lCCS);
      matLCCS(idxPhi, idxTheta, idxPsi) = maxLCCS;
      maxLoc = [lr(idxMaxLCCS(1)) lc(idxMaxLCCS(2)) lp(idxMaxLCCS(3))];
      if maxLCCS > peakLCCS
          peakLCCS = maxLCCS;
          peakLoc = maxLoc;
          peakDelRotate = delRotate;
          peakRotation = totalRotation;
          [lPeakValue peakShift] = ...
            peakInterp3(lr, lc, lp, lCCS, maxLoc, 1, 0.02);
      end
      if flgVerbose
        fprintf('Del phi: %6.2f  theta: %6.2f  psi: %6.2f', ...
          delRotate * 180/pi);
        fprintf('  LCCS %f @ shift %6.2f %6.2f %6.2f\n', ...
          maxLCCS, maxLoc)
      end

      if flgVerbose > 3
        fprintf('Writing out rotated volume\n');
        junk = ...
          save(MRCImage(rotPOI), ['rot'  strIDPhi strIDTheta strIDPsi '.mrc']);
        clear junk
      end
      idxPsi = idxPsi + 1;
    end % Psi
    idxTheta = idxTheta + 1;    
  end % Theta
  idxPhi = idxPhi + 1;
end % Phi

if flgVerbose
  fprintf('\nPeak del  phi: %6.2f  theta: %6.2f  psi: %6.2f\n', ...
    peakDelRotate(1) * 180/pi, ...
    peakDelRotate(2) * 180/pi, ...
    peakDelRotate(3)* 180/pi)
  fprintf('Max CCS @ phi: %6.2f  theta: %6.2f  psi: %6.2f', ...
    peakRotation(1) * 180/pi,  ...
    peakRotation(2) * 180/pi, ...
    peakRotation(3) * 180/pi)
  fprintf('  CCS %f @ indices %6.2f %6.2f %6.2f\n', peakLCCS, peakLoc)
  fprintf(' Interpolated shift %6.2f %6.2f %6.2f\n', peakShift);
  fprintf('Elapsed time %d\n\n', etime(clock, st));
end

if flgVerbose > 3
  fprintf('Writing out aligned volume\n');
  aligned = volumeRotateShift(rotateVol, peakRotation, peakShift);
  junk = save(MRCImage(aligned), 'aligned_plus.mrc');
  clear junk
  aligned = volumeRotateShift(rotateVol, peakRotation, -1 * peakShift);
  junk = save(MRCImage(aligned), 'aligned_minus.mrc');
  
end
  