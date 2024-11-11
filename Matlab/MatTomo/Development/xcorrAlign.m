%
% Load the Header from the dataset
%
dataset = 'MT_pombe3';
mRCImage = MRCImage([dataset '.st'], 0);

tiltAxisAngle = -28.2 / 180 * pi;
interpMethod='nearest';

% Load in the raw tilt file
rawTilt = load(dataset.rawtlt);


% Compute the rotation coordinates
coordSrcDataX = [-(getNX(mRCImage)-1)/2:getNX(mRCImage)/2];
coordSrcDataY = fliplr([-(getNY(mRCImage)-1)/2:getNY(mRCImage)/2]);

rotation = [cos(tiltAxisAngle) -sin(tiltAxisAngle);
            sin(tiltAxisAngle) cos(tiltAxisAngle)];


% 
roiX = 512:1024+511;
roiY = 512:1024+511;
[cmSrcX cmSrcY] = meshgrid(coordSrcDataX(roiX), coordSrcDataY(roiY));
coordSrc = [cmSrcX(:)'; cmSrcY(:)'];
coordRot = rotation * cordSrc;
cmRotX = reshape(coordRot(1,:), getNY(mRCImage), getNX(mRCImage));
cmRotY = reshape(coordRot(2,:), getNY(mRCImage), getNX(mRCImage));

% Extract and rotate the reference image

for i = getNZ(mRCImage):-1:1
  %  Rotate the image
%   disp(int2str(i))
%   srcImage = double(getImage(mRCImage, i))
%   im = interp2(coordSrcDataX, coordSrcDataY, srcImage, ...
%                cmRotX, cmRotY, interpMethod);
%   imStack(:,:,i) = im(1:4:end, 1:4:end);
% end

% for i = 1:getNZ(mRCImage)
%   showMRCImage(imStack(:,:,i));
%   caxis([-100 800])
%   drawnow
% end
close(mRCImage);
