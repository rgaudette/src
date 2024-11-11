if exist('ax6', 'var') ~= 1
  ax6 = MRCImage('ax6flipped.byte')
end

contourModel = 'dyneinContour6b.mod';
referenceParticles = 'dynein67.mod';

[idxLocalMin tube] = ...
    findDyneinSearchPos(ax6, contourModel, referenceParticles);
[dynein6loc dynein6tube maxCC6 avgDynein6] = ...
    findDyneinParticles(tube, idxLocalMin, contourModel, referenceParticles);

saveModel('dyn6Particles', dynein6loc)

save dynein6run contourModel referenceParticles idxLocalMin tube ...
  dynein6loc dynein6tube maxCC6 avgDynein6
