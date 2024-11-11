

function fairReferenceReview(volume, imodParticle, szVol, select, ...
  stTransform, finalEuler)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: fairReferenceReview.m,v 1.3 2005/08/15 23:17:36 rickg Exp $\n');
end

idxOrigin = floor(szVol / 2) + 1;

% Get the particle centers from the point model and convert to a MATLAB
% array indices.  
ptsParticles = imodPoints2Index(getPoints(imodParticle, 1, 1));

% Load each of the volumes into an array of volumes

nSelect = length(select);
volumes = zeros(szVol(1), szVol(2), szVol(3), nSelect, 'single');
iParticle = 1;
for iSelect = select
  volumes(:,:,:, iParticle) = ...
    single(extractSubVolume(volume, ptsParticles(:, iSelect), szVol));

  % Frequency domain filter it if required
  %SUBVOL = fftn(subvol);
  %if flgFreqFilt
  %  SUBVOL = SUBVOL .* fltBandpass;
  %end

  % Zero out any DC in the sub-volume if requested
  %if flgMeanRemove
  %  SUBVOL(1, 1, 1) = 0;
  %end
  %volumes(:,:,:, iParticle) = ifftn(SUBVOL);
  iParticle = iParticle + 1;
end

% Walk through the first set of alignments displaying the aligned and
% unaligned volumes and the average

nPairs = nSelect / 2;

for iPair = 1:nPairs
  figure(1)
  colormap(gray(256))
  stackGallery(volumes(:,:,:, stTransform(iPair).iFixed));
  
  figure(2)
  colormap(gray(256))
  stackGallery(volumes(:,:,:, stTransform(iPair).iRot));

  figure(3)
  colormap(gray(256))
  stackGallery(volumeRotateShift(...
    volumes(:,:,:, stTransform(iPair).iRot), ...
    stTransform(iPair).rotate, stTransform(iPair).shift, idxOrigin));

  fprintf('Pair index %d\n', iPair);

end