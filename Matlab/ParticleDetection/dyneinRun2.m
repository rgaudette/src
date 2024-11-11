if exist('ax6', 'var') ~= 1
  ax6 = MRCImage('ax6flipped.byte')
end

contourModel = 'dyneinContour2b.mod';
referenceParticles = 'dynein23.mod';

[idxLocalMin tube] = ...
    findDyneinSearchPos(ax6, contourModel, referenceParticles);
[dynein2loc dynein2tube maxCC2 avgDynein2] = ...
    findDyneinParticles(tube, idxLocalMin, contourModel, referenceParticles);

saveModel('dyn2Particles', dynein2loc)

save dynein2run contourModel referenceParticles idxLocalMin tube ...
  dynein2loc dynein2tube maxCC2 avgDynein2
