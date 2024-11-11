%asModify       Modify an alignment structure
%
%   asOut = asModify(asIn, shift, preRotate, postRotate)
%
%   asOut, asIn The output and input alignment structures.
%
%   shift       An offset add to the translational shift operation [dx dy dz].
%
%   preRotate   An Euler rotation applied before the rotation proscribed in the
%               alignment structure [Phi Theta Psi] (radians).
%
%
%   postRotate  An Euler rotation applied after the rotation proscribed in the
%               alignment structure [Phi Theta Psi] (radians).
%
%   asModify modifies the translational shift and Euler rotation entries in the
%   specified alignment structure.  Each of the modification parameters can
%   either be a 3 element vector or a 3xN array.  A 3 element vector will
%   updated each entry in the alignment structure with the same value.  A 3xN
%   array allows for individial modifications of the entries.
%
%   WARNING: The alignment strcuture specifies how to rotate then shift the
%   reference to align it with the particle.  To add a rotation to particle
%   average use the preRotate parameter.
%
%   Bugs: none known

function asOut = asModify(asIn, shift, preRotate, postRotate)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: asModify.m,v 1.4 2005/08/15 23:17:36 rickg Exp $\n');
end

nParticles = size(asIn, 2);

if any(size(shift) == 1)
  shift = repmat(shift(:), 1, nParticles);
end

if any(size(preRotate) == 1)
  preRotate = repmat(preRotate(:), 1, nParticles);
end

if any(size(postRotate) == 1)
  postRotate = repmat(postRotate(:), 1, nParticles);
end

asOut = asIn;
asOut([11:13], :) = asOut([11:13], :) + shift;

% TODO need to validate that eulerSum can do more than one angle per call
for i = 1:nParticles
  temp = eulerRotateSum(preRotate(:, i), asOut([17 19 18], i) * pi / 180);
  asOut([17 19 18], i) = eulerRotateSum(temp, postRotate(:, i)) * 180 /pi;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  $Author: rickg $
%
%  $Date: 2005/08/15 23:17:36 $
%
%  $Revision: 1.4 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
