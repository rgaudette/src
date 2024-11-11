if exist('ax6', 'var') ~= 1
  ax6 = MRCImage('ax6flipped.byte')
end

contourModel = 'dyneinContour4b.mod';
referenceParticles = 'dynein45.mod';

[idxLocalMin tube] = ...
    findDyneinSearchPos(ax6, contourModel, referenceParticles);
[dynein4loc dynein4tube maxCC4 avgDynein4] = ...
    findDyneinParticles(tube, idxLocalMin, contourModel, referenceParticles);

saveModel('dyn4Particles', dynein4loc)

save dynein4run contourModel referenceParticles idxLocalMin tube ...
  dynein4loc dynein4tube maxCC4 avgDynein4
