subplot(9,1,1)
for iMT = 1:9
  subplot(9, 1, iMT);
  tube = interpTube2(ax6, getPoints(mt2, iMT, 1)', [1 1 1], [100 3], ...
                     'nearest');
  colormap(gray(256))
  imagesc(rot90(tube(:,:,2)));
  axis('image')
end
