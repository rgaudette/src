if exist('ax6', 'var') ~= 1
  ax6 = MRCImage('ax6flipped.byte')
end

% Change back to b once it is fixed
contourModel = 'dyneinContour5.mod';
referenceParticles = 'dynein56.mod';

[idxLocalMin tube] = ...
    findDyneinSearchPos(ax6, contourModel, referenceParticles);
[dynein5loc dynein5tube maxCC5 avgDynein5] = ...
    findDyneinParticles(tube, idxLocalMin, contourModel, referenceParticles);

saveModel('dyn5Particles', dynein5loc)

save dynein5run contourModel referenceParticles idxLocalMin tube ...
  dynein5loc dynein5tube maxCC5 avgDynein5
