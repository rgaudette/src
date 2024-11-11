if exist('ax6', 'var') ~= 1
  ax6 = MRCImage('ax6flipped.byte')
end

contourModel = 'dyneinContour7b.mod';
referenceParticles = 'dynein78.mod';

[idxLocalMin tube] = ...
    findDyneinSearchPos(ax6, contourModel, referenceParticles);
[dynein7loc dynein7tube maxCC7 avgDynein7] = ...
    findDyneinParticles(tube, idxLocalMin, contourModel, referenceParticles);

saveModel('dyn7Particles', dynein7loc)

save dynein7run contourModel referenceParticles idxLocalMin tube ...
  dynein7loc dynein7tube maxCC7 avgDynein7
