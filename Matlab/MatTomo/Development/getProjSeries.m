function projSeries = getProjSeries(mRCImage, index)


nProj = getNZ(mRCImage);
projSeries = zeros(getNX(mRCImage), nProj);

for iProj = 1:nProj
  proj = getImage(mRCImage, iProj);
  projSeries(:, iProj) = proj(:,index);
end

