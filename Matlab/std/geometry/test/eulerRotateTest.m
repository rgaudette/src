function eulerRotateTest
% Test the eulerRotate function

% Rotate a X unit vector to Y
v = [1 0 0]';
rot = eulerRotate(v, [pi/2 0 0])
test(rot, [0 1 0]', 'Rotate X -> Y');


% Rotate a X unit vector to Z via phi=90, theta=90
v = [1 0 0]';
rot = eulerRotate(v, [pi/2 pi/2 0])
test(rot, [0 0 1]', 'Rotate X -> Z');

% Rotate a X unit vector to [sqrt(2)/2 0  sqrt(2)/2] via phi=45, theta=90
v = [1 0 0]';
rot = eulerRotate(v, [pi/4 pi/2 0])
test(rot, [sqrt(2)/2 0  sqrt(2)/2]', 'Rotate X -> [sqrt(2)/2 0  sqrt(2)/2]');


v = [-sqrt(2)/2 -sqrt(2)/2 0]';
rot = eulerRotateInv(v, [0  pi/2 -pi/4])
test(rot, [0 0 1]', 'Rotate [-sqrt(2)/2 -sqrt(2)/2] - > Z');

function test(rot, expected, label)
test = expected - rot;
if sqrt(sum(test .^ 2)) > 1E-10
  warning([label ' failed'])
else
  disp([label ' passed']);
end
disp(' ')
