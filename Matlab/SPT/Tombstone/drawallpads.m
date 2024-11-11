%drawAllPads    Imagesc all of the pads in a padStruct
%
%  drawallpads(padStruct, plotLayout)
%
%  Status: functional

function drawAllPads(padStruct, plotLayout)
if nargin < 2
  plotLayout = [4 2];
end
nPlots = prod(plotLayout);

clf
nPad = length(padStruct);
nComp = nPad / 2;

for iPad = 1:nPad
  iComp = ceil(iPad/2);

  subplot(4, 2, rem(iPad, 8));
  imagesc(padStruct(iPad).image);
  if rem(iComp, 4) == 0
    figure
  end
end
