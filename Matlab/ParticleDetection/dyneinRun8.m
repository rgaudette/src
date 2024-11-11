if exist('ax6', 'var') ~= 1
  ax6 = MRCImage('ax6flipped.byte')
end

contourModel = 'dyneinContour8b.mod';
referenceParticles = 'dynein89.mod';

[idxLocalMin tube] = ...
    findDyneinSearchPos(ax6, contourModel, referenceParticles);
[dynein8loc dynein8tube maxCC8 avgDynein8] = ...
    findDyneinParticles(tube, idxLocalMin, contourModel, referenceParticles);

saveModel('dyn8Particles', dynein8loc)

save dynein8run contourModel referenceParticles idxLocalMin tube ...
  dynein8loc dynein8tube maxCC8 avgDynein8
