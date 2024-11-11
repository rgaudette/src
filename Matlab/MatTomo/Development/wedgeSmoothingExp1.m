% load in the MRCImage structure
stack = MRCImage('ax6.byteWedge', 0);
maxTilt = 61.94 * pi / 180; % 63
minTilt = -57.34 * pi / 180; % -56.99

% get the X-Z image
im = double(rot90(getImage(stack, 1)));
% compute the DFT of the image
IM = fftshift(fftn(im));
szIM = size(IM);
center = floor(szIM / 2) + 1;
[fy fx] = ndgrid(([1:szIM(1)] - center(1)) ./ szIM(1), ...
                 ([1:szIM(2)] - center(2)) ./ szIM(2));

angle = atan2(fy, fx);
fmag = sqrt(fx .^ 2 + fy .^ 2);

% Low pass filter
cutoff = 0.35;
fTransWidth = 0.01;
fMask = zeros(szIM);
fPass = fmag <= cutoff;
fMask(fPass) = 1;
idxCutoff = ~fPass;
fMask(idxCutoff) = gaussian(fmag(idxCutoff), cutoff, fTransWidth);
  
% Missing wedge filter
zeroMask = (fx >= 0) & (angle <= maxTilt) & (angle >= minTilt) ...
    | (fx < 0) & (angle <= maxTilt-pi)  ...
    | (fx < 0) & (angle >= minTilt+pi);

transwidth = 10 * pi /180;
transMaskMaxPlus = 1 - gaussian(atan2(fy, fx), maxTilt, transwidth);
transMaskMaxMinus = 1 - gaussian(atan2(fy, fx), maxTilt-pi, transwidth);
transMaskMinPlus = 1 - gaussian(atan2(fy, fx), minTilt, transwidth);
transMaskMinMinus = 1 - gaussian(atan2(fy, fx), minTilt+pi, transwidth);
totalMask = zeroMask .* transMaskMaxPlus .* transMaskMaxMinus ...
    .* transMaskMinPlus .* transMaskMinMinus;% .* fMask;

% Loop over the slices in the stack
nSlices = getNZ(stack);
for iSlice = 1:nSlices
  fprintf('Slice %d\n', iSlice);
  % get the X-Z image
  im = double(rot90(getImage(stack, iSlice)));
  % compute the DFT of the image
  IM = fftshift(fftn(im));

  IMmask = IM .* totalMask;
  immask = real(ifftn(ifftshift(IMmask)));
  
%   figure(3)
%   IMmaskDb = 10*(log10(abs(IMmask)));
  
%   IMmaskDb(center(1), center(2)) = 0;
%   IMmaskDb =   IMmaskDb - max(IMmaskDb(:));
%   imagesc(IMmaskDb)
%   caxis([-25 0])
  
%   set(3, 'position', get(1, 'position'));
%   axis('square')
    
%   figure(4)
%   subplot(3,1,1);
%   imagesc(im);
%   axis('image');
%   caxis([100 134])

%   subplot(3,1,2);

%   imagesc(immask);
%   caxis([100 134])
%   axis('image')

%   subplot(3,1,3);
%   imagesc(im - immask);
%   axis('image')
  
%   figure(5)
%   imagesc(im(:,150:450));
%   axis('image');

%   figure(6)
%   set(6, 'position', get(5, 'position'));
%   imagesc(immask(:,150:450));
%   axis('image');

  % put the X-Z image back into the stack
  stack = putImage(stack, rot90(immask, -1), iSlice);
end
