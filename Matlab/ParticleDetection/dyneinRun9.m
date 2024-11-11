if exist('ax6', 'var') ~= 1
  ax6 = MRCImage('ax6flipped.byte')
end

contourModel = 'dyneinContour9b.mod';
referenceParticles = 'dynein91.mod';

[idxLocalMin tube] = ...
    findDyneinSearchPos(ax6, contourModel, referenceParticles);
[dynein9loc dynein9tube maxCC9 avgDynein9] = ...
    findDyneinParticles(tube, idxLocalMin, contourModel, referenceParticles);

saveModel('dyn9Particles', dynein9loc)

save dynein9run contourModel referenceParticles idxLocalMin tube ...
  dynein9loc dynein9tube maxCC9 avgDynein9
