%diffApprox     Compute the derivative approximation as it is in Chip
%
%  diffProf = diffApprox(prof, nSmooth, diffStep)
%
%  Status: functional

function diffProf = diffApprox(profs, nSmooth, diffStep)
if nargin < 3
  diffStep = 1;
end
  
if nargin < 2
  nSmooth = 1;
end

[nProfs nSamples] = size(profs);

%%
%%  Smooth the profile in the same manner as the prim.c function
%%  MakeSmooth
%%
hSmooth = ones(nSmooth, 1) ./ nSmooth;
nRepeat = floor(nSmooth / 2);
smoothProf = zeros(nProfs, nSamples);
for iProf = 1:nProfs
  %%
  %%  Repeat end element as in MakeSmooth
  %%
  begRep = ones(1, nRepeat) * profs(iProf, 1);
  endRep = ones(1, nRepeat) * profs(iProf, end);  
  temp = conv(hSmooth, [begRep profs(iProf, :) endRep]);
  smoothProf(iProf, :) = temp(nSmooth:nSamples+nSmooth-1);
end

%%
%%  Derivative filter impulse response
%%
hDiff(1) = 1 / diffStep;
hDiff(diffStep+1) = -1 / diffStep;
nFilt = length(hDiff);

%%
%%  Approximate the derivative as in MakeDerivs
%%
nRepeat = floor(nFilt / 2);
diffProf = zeros(nProfs, nSamples);
%diffProf = zeros(nProfs, nSamples-nFilt+1);
%diffProf = zeros(nProfs, nSamples+nFilt-1);
for iProf = 1:nProfs
  %%
  %%  Repeat end element as in MakeDeriv
  %%
  begRep = ones(1, nRepeat) * smoothProf(iProf, 1);
  endRep = ones(1, nRepeat) * smoothProf(iProf, end);  

  temp = conv([begRep smoothProf(iProf, :) endRep], hDiff);
  diffProf(iProf, :) = temp(nFilt:nSamples+nFilt-1);
%  diffProf(iProf, :) = temp(nFilt:end-nFilt+1);
  %diffProf(iProf, :) = conv(smoothProf(iProf, :), hDiff);
end
