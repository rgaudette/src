%oldProc        A model of the old cap spine processing technique
%
%  stats = oldproc(profs, nSmooth, diffStep, flgVerbose)
%
%  Status: functional

function stats = oldProc(profs, nSmooth, diffStep, flgVerbose)
if nargin < 4
  flgVerbose = 0;
end

if nargin < 3
  diffStep = 1;
end
if nargin < 2
  nSmooth = 1;
end

milsPerPixel = 800 / (1024-1);

%%
%%  Filter impulse responses
%%
hSmooth = ones(nSmooth, 1) ./ nSmooth;
nDiff = diffStep + 1;
hDiff(1) = 1;
hDiff(nDiff) = -1;
hDiff = hDiff ./ (nDiff-1);
%%
%%  smooth, differentiate and detect each profile in the structure
%%
if flgVerbose
  fprintf(['Comp\tProf#\tMax\t\tiMax\tmin\t\tiMin\tpwPos\t\tpwNeg\t\tppwrPos\' ...
           ' t\tppwrNeg\t\tppwrMean\n']);
end
nComp = length(profs);
stats.nComp = nComp;
for i = 1:nComp
  [nProf nElem] = size(profs(i).Profile);
  stats.nProf = nProf;
  
  for j = 1:nProf
    %%
    %%  Smooth the profiles by the specified amount
    %%
    smoothed = conv(hSmooth, profs(i).Profile(j,:)');
    smoothed = smoothed(nSmooth:end-nSmooth+1);
    
    %%
    %%  Compute the two point, nth step difference
    %%
    diffed = conv(hDiff, smoothed);
    diffed = diffed(nDiff:end-nDiff+1);
    nDiffed = length(diffed);
    
    %%
    %%  locate min and max
    %%
    [valMax idxMax] = max(diffed);
    [valMin idxMin] = min(diffed);
    
    %%
    %%  Find 50% width around min and max
    %%
    [idxPosPulseStart idxPosPulseStop] = findHalfMaxWidth(diffed);
    [idxNegPulseStart idxNegPulseStop] = findHalfMaxWidth(-1 * diffed);

    %%
    %%  Calculate peak-to-pulse-width-ratio (h:w)
    %%

    pwPos = (idxPosPulseStop - idxPosPulseStart) * milsPerPixel;
    ppwrPos = valMax / pwPos;
    pwNeg = (idxNegPulseStop - idxNegPulseStart) * milsPerPixel;
    ppwrNeg = abs(valMin / pwNeg);
    ppwrMean = 0.5 *(ppwrPos + ppwrNeg);
 
    %%
    %%  Print out result and add to return struct
    %%
    if flgVerbose
      fprintf('%s\t%d\t%f\t%d\t%f\t%d\t%f\t%f\t%f\t%f\t%f\n', ...
              profs(i).Name, j, valMax, idxMax, valMin, ...
            idxMin, pwPos, pwNeg, ppwrPos, ppwrNeg, ppwrMean);
    end
    stats.Max(j+(i-1)*nProf) = valMax;
    stats.iMax(j+(i-1)*nProf) = idxMax;
    stats.Min(j+(i-1)*nProf) = valMin;
    stats.iMin(j+(i-1)*nProf) = idxMin;
    stats.pwPos(j+(i-1)*nProf) = pwPos;
    stats.pwNeg(j+(i-1)*nProf) = pwNeg;
    stats.ppwrPos(j+(i-1)*nProf) = ppwrPos;
    stats.ppwrNeg(j+(i-1)*nProf) = ppwrNeg;
    stats.ppwr(j+(i-1)*nProf) = ppwrMean;
  end
  if flgVerbose
    fprintf('\n');
  end
  
end

stats = all4AvgPPWR(stats);

%%
%%  calculate the mean and standard deviations necesary
%%
% idxBody = [1:nProf:length(stats.ppwrPos) 2:nProf:length(stats.ppwrPos)];
% idxPin = idxBody + 2;
% stats.meanPPWR = mean([stats.ppwrPos stats.ppwrNeg]);
% stats.meanPinPPWR = mean([stats.ppwrPos(idxPin) stats.ppwrNeg(idxPin)]);
% stats.meanBodyPPWR = mean([stats.ppwrPos(idxBody) stats.ppwrNeg(idxBody)]);

% stats.stdPPWR = std([stats.ppwrPos stats.ppwrNeg]);
% stats.stdPinPPWR = std([stats.ppwrPos(idxPin) stats.ppwrNeg(idxPin)]);
% stats.stdBodyPPWR = std([stats.ppwrPos(idxBody) stats.ppwrNeg(idxBody)]);

%%
%% findHalfMaxWidth
%%
function [idxStart, idxStop] = findHalfMaxWidth(signal);
nSignal = length(signal);
[valMax idxMax] = max(signal);
i = idxMax;
threshold = 0.5 * valMax;
while signal(i) > threshold
  i = i - 1;
  if i == 0
    break;
  end
end
idxStart = i;

i = idxMax;
while signal(i) > threshold
  i = i + 1;
  if i > nSignal
    break;
  end
end
idxStop = i;


%%
%%  Calculate the average PPWR for each pin using all four spines
%%
function stats = all4AvgPPWR(stats)
stats.all4AvgPPWR = zeros(stats.nComp, 2);
for i = 1:stats.nComp
  idxCompStart = (i - 1) * stats.nProf + 1;
  stats.all4AvgPPWR(i, 1) = 0.5 * (stats.ppwr(idxCompStart) + stats.ppwr(idxCompStart+2));
  stats.all4AvgPPWR(i, 2) = 0.5 * (stats.ppwr(idxCompStart+1) + stats.ppwr(idxCompStart+3));
end

