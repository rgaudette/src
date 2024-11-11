function eulerRotateTest
% Test the eulerRotate function

% Rotate a X unit vector to Y
v = [1 0 0]';
rot = eulerRotateInv(v, [0 0 pi/2])
test(rot, [0 1 0]', 'Rotate X -> Y');


% Rotate a X unit vector to Z via phi=90, theta=90
v = [1 0 0]';
rot = eulerRotateInv(v, [0 pi/2 pi/2])
test(rot, [0 0 1]', 'Rotate X -> Z');

% Rotate a X unit vector to [0 sqrt(2)/2 sqrt(2)/2] via psi=45, theta=90
v = [1 0 0]';
rot = eulerRotateInv(v, [0 pi/2 pi/4])
test(rot, [sqrt(2)/2 0 sqrt(2)/2]', 'Rotate X -> [sqrt(2)/2 0 sqrt(2)/2]');

function test(rot, expected, label)
test = expected - rot;
if sqrt(sum(test .^ 2)) > 1E-10
  warning([label ' failed'])
else
  disp([label ' passed']);
end
disp(' ')
