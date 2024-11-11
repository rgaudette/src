if exist('ax6', 'var') ~= 1
  ax6 = MRCImage('ax6flipped.byte')
end

contourModel = 'dyneinContour3b.mod';
referenceParticles = 'dynein34.mod';

[idxLocalMin tube] = ...
    findDyneinSearchPos(ax6, contourModel, referenceParticles);
[dynein3loc dynein3tube maxCC3 avgDynein3] = ...
    findDyneinParticles(tube, idxLocalMin, contourModel, referenceParticles);

saveModel('dyn3Particles', dynein3loc)

save dynein3run contourModel referenceParticles idxLocalMin tube ...
  dynein3loc dynein3tube maxCC3 avgDynein3
