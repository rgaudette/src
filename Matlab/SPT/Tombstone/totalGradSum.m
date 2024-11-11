%totalGradSum   Compute the total gradient sum of a pad
%
%  total = totalGradSum(pad)
%
%  Status: under development
function total = totalGradSum(pad)


if pad.rotation
  pad.image = pad.image';
end

medianed = medfilt2(pad.image, [5 5]);
medianed = medianed(2:end-1,2:end-1);

clf
cvec = [75:2.5:175];
subplot(2,2,1);
contour(medianed,cvec )
grid on
title('Median Filtered')

nAvg = 2;
smoothed = conv2(medianed, ones(nAvg), 'valid')./ nAvg^2;

subplot(2,2,2);
contour(smoothed, cvec)
grid on
title('Averaged Filtered')


%%
%%  Vertical derivative
%%
vdStep = 10;
[nr nc] = size(smoothed);
vDeriv = (smoothed(1:nr-vdStep,:) - smoothed(vdStep+1:nr,:)) ./ vdStep;
%[fx fy] = gradient(smoothed);
nPix = length(vDeriv(:));

subplot(2,2,3)
%cvec = [0:0.5:max(max(abs(fx)),max(abs(fy)))];
imagesc(vDeriv.^2)
grid on
colorbar('vert')

%subplot(2,2,4)
%contour(abs(fy),cvec)
%grid on

%gradNorm = abs(fx+j*fy);
%gradNorm = (fy);

total = sum(vDeriv(:).^2) ./ nPix

% subplot(2,2,3);
% imagesc(gradNorm);
% colorbar('vert')
% title('Gradient norm')

subplot(2,2,4)
plot(vDeriv.^2)
drawnow
pause