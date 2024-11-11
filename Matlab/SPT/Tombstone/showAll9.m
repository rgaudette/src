function showAll9(resultsBlock, crange)
clf

for idx = 1:9
  subplot(3,3,idx)
  imagesc(resultsBlock(:,:,idx), crange)
  xlabel('Deriv Step Size');
  ylabel('Smoothing Parameter');
  grid
  colorbar('vert')
end
