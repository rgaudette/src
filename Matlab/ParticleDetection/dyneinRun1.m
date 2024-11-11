if exist('ax6', 'var') ~= 1
  ax6 = MRCImage('ax6flipped.byte')
end

contourModel = 'dyneinContour1b.mod';
referenceParticles = 'dynein12.mod';

[idxLocalMin tube] = ...
    findDyneinSearchPos(ax6, contourModel, referenceParticles);
[dynein1loc dynein1tube maxCC1 avgDynein1] = ...
    findDyneinParticles(tube, idxLocalMin, contourModel, referenceParticles);

saveModel('dyn1Particles', dynein1loc)

save dynein1run contourModel referenceParticles idxLocalMin tube ...
  dynein1loc dynein1tube maxCC1 avgDynein1
