%diffProf       Compute and plot the differential of a set of profiles
%
%  Status: functional

function diffProf(profs, nSmooth, diffStep)
if nargin < 3
  diffStep = 1;
end
  
if nargin < 2
  nSmooth = 1;
end

%%
%%  Filter impulse responses
%%
hSmooth = ones(nSmooth, 1);
hDiff(1) = 1;
hDiff(diffStep+1) = -1;
nFilt = length(hDiff);

nComp = length(profs);
clf
for i = 1:nComp
  subplot(nComp, 1, i);
  [nProfs nElem] = size(profs(i).Profile);
%  D = zeros(nElem-nFilt+1, nProfs);
  for j = 1:nProfs
    %%
    %%  Smooth the profiles by the specified amount
    %%
    smoothed = conv(hSmooth, profs(i).Profile(j,:)');
    smoothed = smoothed(nSmooth:end-nSmooth+1);

    %%
    %%  Compute the difference x(n+k) - x(n)
    %%
    d = conv(smoothed, hDiff);
    D(:,j) = d(nFilt:end-nFilt+1);
  end
  %plot([1:length(D(:,1))] .* (850/1024),D);
  %xlabel('Mils')
  plot(D);
  hold on
  grid on

  title(profs(i).Name);
end
