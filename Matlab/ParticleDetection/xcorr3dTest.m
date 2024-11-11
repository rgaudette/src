%xcorr3dTest    Test script for xcorr3d

% k1 = zeros(3,3,3);
% k1(:,:,1) = [1 0 0
%              0 0 0
%              0 0 0];
% k1(:,:,2) = [1 1 0
%              1 0 0
%              0 0 0];
% k1(:,:,3) = [1 1 1
%              1 1 0
%              1 0 0];

% x1 = zeros(30,117,5);
% shift = [1 20 1]
% iRange = shift(1):shift(1)+size(k1,1)-1;
% jRange = shift(2):shift(2)+size(k1,2)-1;
% kRange = shift(3):shift(3)+size(k1,3)-1;
% x1(iRange, jRange, kRange) = k1;
% xcFunc = xcorr3d(x1, k1);
% [val idx] = arraymax(xcFunc)

vol2 = randn(30, 25, 20)*0.1;
k2 = randn(5,4,6);
shift = [10 15 4];
vol2([0:4]+shift(1), [0:3]+shift(2), [0:5]+shift(3)) = k2;
ccFunc = xcorr3d(vol2, k2, 'valid');
