nParticles = 10;
szVol = [256 256 100];
length = 20;
width = 3;
bufferDist = 10;

[vol, reference, modParticle, motiveList] = ...
  randomTestVolume(szVol, nParticles, length, width, bufferDist);

szAvgVol = [32 32 32];
threshold = 10;
[avgVol nAvg threshold idxSelected] = ...
  motlAverage3(MRCImage(vol), modParticle, szAvgVol, motiveList, threshold);

stackGallery(avgVol)
