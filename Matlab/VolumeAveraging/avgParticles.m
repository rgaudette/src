function average = avgParticles(basename, indices);

global PRINT_ID
if PRINT_ID
    fprintf('$Id: avgParticles.m,v 1.3 2005/08/15 23:17:36 rickg Exp $\n');
end

v = getVolume(MRCImage([basename '_' int2str(1) '.mrc']), [], [],[]);
vsum = zeros(size(v));

nAvg = 0;
for idx = indices
  nAvg = nAvg + 1;
  v = getVolume(MRCImage([basename '_' int2str(idx) '.mrc']), [], [],[]);
  vsum = vsum + double(v);
end
vsum = vsum ./ nAvg;

save(MRCImage(vsum), [basename '.avg']);
