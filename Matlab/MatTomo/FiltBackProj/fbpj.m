function [volume] = fbpj(proj, theta, fc, ft , xPoints, zPoints)

theta = theta * pi / 180;

%% Antialiasing experiemnt: interpolate the to increas the number of projections
nInterp = 4;
tSamp = [1:1/nInterp:length(theta)];
thetaInterp = interp1([1:length(theta)], theta, tSamp);
theta = thetaInterp;
projInterp = interp2(proj, tSamp, [1:size(proj,1)]');
proj = projInterp;
size(proj)
% Antialiasing experiemnt: decimate the projection sampling
nDec = 2;
avgProj = filter(ones(nDec, 1), 1, proj);
avgProj = avgProj(1:nDec:end, :);
proj = avgProj;

nSamples = size(proj, 1)
nProjections = size(proj, 2)

% if xPoints is empty cacluate the full volume given the range of z and the
% the number of samples
%
% Assumptions: the range of tilts is greater than:
%  atan(max(zPoints)/max(xPoints))

% Calculate the FFT size necessary to prevent spatial aliasing and the
% ramp filter
nFFT = 2 ^ nextpow2(2 * nSamples);
[H nRamp] = calcRamp(fc, ft, nFFT);


if isempty(xPoints)
  projDomainMax = (nSamples - nRamp - 1) / 2;
  xMax = floor(min(sqrt((projDomainMax)^2 - max(zPoints)^2), ...
             sqrt((projDomainMax)^2 - min(zPoints)^2))) - 1
  xPoints = [-xMax:xMax];
end


% Calculate the interpolation indices for each projection angle
% using a linear interpolation
[idxLow, wLow, idxHigh, wHigh] = ...
    interpWeights(nSamples - nRamp, theta, xPoints, zPoints);

% Loop over each slice computing the filtered back projection
nX = length(xPoints);
nZ = length(zPoints);

volume = zeros(nX, nZ);
% Filter the projection and truncate the zero padding off
PROJ = fft(proj, nFFT);
for iTheta = 1:nProjections
  %% TODO get the length of the ramp filter to remove the transients
  temp = real(ifft(PROJ(:,iTheta) .* H));

  filtproj = temp(nRamp+1:nSamples);
  lower =  wLow(:, :, iTheta) .* filtproj(idxLow(:, :, iTheta));
  upper = wHigh(:, :, iTheta) .* filtproj(idxHigh(:, :, iTheta));
  volume = volume  + lower + upper;
end
  

%%
%%  Calculate the linear back projection interpolate weights and indices
%%  TODO: probably need to zero out the weights and set the indices to one
%%  for any X-Z coordinate out of the domain of the projection
%%
function [idxLow, wLow, idxHigh, wHigh] = ...
    interpWeights(nSamples, theta, xPoints, zPoints)

nXPoints = length(xPoints);
nZPoints = length(zPoints);
[xPoints zPoints] =  ndgrid(xPoints, zPoints);

% t contains the coordiate along the projection for each point in X and Z
% and for each theta
% TODO: can (should) this be vectorized
nTheta = length(theta);
t = zeros(nXPoints, nZPoints, nTheta);
for iTheta = 1:nTheta
  t(:, :, iTheta) = xPoints .* cos(theta(iTheta)) ...
      + zPoints .* sin(theta(iTheta)) + nSamples / 2;
end
% Generate the linear interpolation weights and indices for each
% The mapping from position to index requires the addition of 1 since
% MATLAB uses base 1 indexing
idxLow = floor(t + 1);
idxHigh = idxLow + 1;
wHigh = (t - idxLow);
wLow = 1 - wHigh;


%%
%%  Calculate the ramp filter
%%
%%  fc   The cutoff frequency of the filter (cycles/sample)
%%
%%  ft   The transition width between the pass and stop bands (cycles/sample)
%%
function [H, n] = calcRamp(fc, ft, nPoints)
[n wn beta ftype] = kaiserord([2*fc 2*(fc + ft)], [1 0], [0.05 0.05]);
fprintf('Kaiser filter order: %d\n', n);
hlp = fir1(n, wn, ftype, kaiser(n+1, beta));
HLP = fft(hlp', nPoints);
H = HLP .* ([0:nPoints/2-1 nPoints/2-1:-1:0] ./ (nPoints / 2))';
clf
plot([0:nPoints-1]/nPoints, abs(H));
