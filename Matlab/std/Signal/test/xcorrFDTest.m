%xcorrFDTest    Test script for xcorrFD
function allPassed = xcorrFDTest
fuzzy_zero = 20 * eps
% pBase = [1 2 3 4];

% %  1-D no shift non-padded p test
% strTest = '1-D no shift non-padded p test';
% p = pBase;
% s = [ p 0 0 0 0 0 0];
% test1D(p, s, 0, strTest);

% %  1-D -2 shift non-padded p test
% strTest = '1-D -2 shift non-padded p test';
% p = pBase;
% s = [ 0 0 p 0 0 0 0];
% test1D(p, s, -2, strTest);

% %  1-D full shift non-padded p test
% strTest = '1-D full shift non-padded p test';
% p = pBase;
% s = [ 0 0 0 0 0 0 p ];
% test1D(p, s, -6, strTest);

% % 1-D padded p test
% strTest = '1-D 2 shift padded p test';
% p = [0 0 pBase 0 0];
% s = [ pBase 0 0 0 0 0 0];
% test1D(p, s, 2, strTest, 3, 6);

% % 1-D padded p test
% strTest = '1-D 0 shift padded p test';
% p = [0 0 pBase 0 0];
% s = [ 0 0 pBase 0 0 0 0];
% test1D(p, s, 0, strTest, 3, 6);

% %  1-D padded p test
% strTest = '1-D full shift padded p test';
% p = [0 0 pBase 0 0];
% s = [ 0 0 0 0 0 0 pBase];
% test1D(p, s, -4, strTest, 3, 6);

% 1-D different signal test
x = [1 1 1 1];
y = [10 9 8 7 6 0 0 0 0 1 1 1 1];
[rxc lxc] = xcorr(x, y);
[r l] = xcorrFD(x, y);
r = r';
l = l';
idx_first = find(l(1) == lxc);
idx_last = find(l(end) == lxc);
expected_r = rxc(idx_first:idx_last);
expected_l = lxc(idx_first:idx_last);
assert(all(abs(expected_r - r) < fuzzy_zero),  ...
       "Ramp-pulse test signal failed cross-corrlation")
assert(all(expected_l == l), "Ramp-pulse test signal failed lag calculation")

clf
plot(expected_l, expected_r, 'bo')
hold on
plot(l, r, 'r')
return
%%
%% 2-D testing
%%
pBase = reshape([1:9], 3, 3);

% 2-D no shift test
strTest = '2-D zero shift padded p test';
p = zeros(5,5);
p(2:4, 2:4) = pBase;
s = p;
test2D(p, s, [0 0], strTest, [2 2], [4 4]);

% 2-D 1,0 shift test
strTest = '2-D 1,0 shift padded p test';
p = zeros(5,5);
p(2:4, 2:4) = pBase;
s = zeros(5,5);
s(1:3, 2:4) = pBase;
test2D(p, s, [1 0], strTest, [2 2], [4 4]);


% 2-D -2,1 shift test
strTest = '2-D -2,1 shift padded p test';
p = zeros(5,5);
p(2:4, 2:4) = pBase;
s = zeros(6,6);
s(4:6, 1:3) = pBase;
test2D(p, s, [-2 1], strTest, [2 2], [4 4]);

% 2-D -3,-3 shift test
strTest = '2-D -3,-3 shift padded p test';
p = zeros(5,5);
p(2:4, 2:4) = pBase;
s = zeros(7,7);
s(5:7,5:7) = pBase;
test2D(p, s, [-3 -3], strTest, [2 2], [4 4]);


%%
%%  3-D testing
%%
pBase = reshape([1:27], 3, 3, 3);

% 3-D no shift test
strTest = '3-D no shift padded p test';
p = zeros(5, 5, 5);
p(2:4, 2:4, 2:4) = pBase;
s = p;
test3D(p, s, [0 0 0], strTest, [2 2 2], [4 4 4]);

% 3-D 1,-1,1 shift test
strTest = '3-D 1,-1,1 shift padded p test';
p = zeros(5, 5, 5);
p(2:4, 2:4, 2:4) = pBase;
s = zeros(5, 5, 5);
s(1:3, 3:5, 1:3) = pBase;
test3D(p, s, [1, -1, 1], strTest, [2 2 2], [4 4 4]);

% 3-D 2,-5,3 shift test
strTest = '3-D 2,-5,3 shift padded p test';
p = zeros(7,7,7);
p(4:6, 4:6, 4:6) = pBase;
s = zeros(11, 11, 11);
s(2:4, 9:11, 1:3) = pBase;
test3D(p, s, [2, -5, 3], strTest, [4 4 4], [6 6 6]);

%%
%%  1-D test function
%%
function test1D(p, s, expected_max_lag, strTestLabel, p_l, p_h)
disp(strTestLabel)
disp(p)
disp(s)
if nargin > 4
  disp(p_l)
  disp(p_h)
  [r l] = xcorrFD(p, s, p_l, p_h);

else
  [r l] = xcorrFD(p, s);
end

[val idx] = max(r);
disp(r')
disp(l')
disp(idx)
disp(val)
disp(l(idx))
if l(idx) ~= expected_max_lag
  warning('%s failed', strTestLabel);
  fprintf('Peak lag detected:  %d\n', l(idx));
  r
  l
  val
  idx
else
  fprintf('%s ok\n\n', strTestLabel)
end

%%
%%  2-D test function
%%
function test2D(p, s, expected_max_lag, strTestLabel, p_l, p_h)
disp(strTestLabel)
disp(p)
disp('')
disp(s)
disp('')
if nargin > 4
  disp(p_l)
  disp(p_h)
  [r lr lc] = xcorrFD(p, s, p_l, p_h);
else
  [r lr lc] = xcorrFD(p, s);
end
disp(r)
disp(lr)
disp(lc)

[val idxR idxC] = matmax(r);
disp(idxR)
disp(idxC)
disp(lr(idxR))
disp(lc(idxC))

if lr(idxR) ~= expected_max_lag(1) || lc(idxC) ~= expected_max_lag(2)
  warning('%s failed', strTestLabel);
  fprintf('Peak lag detected:  %d, %d\n', lr(idxR), lc(idxC));
  r
  lr
  lc
  val
  idxR
  idxC
else
  fprintf('%s passed\n', strTestLabel)
end

%%
%%  3-D test function
%%
function test3D(p, s, expected_max_lag, strTestLabel, p_l, p_h)
if nargin > 4
  [r lr lc lp] = xcorrFD(p, s, p_l, p_h);
else
  [r lr lc lp] = xcorrFD(p, s);
end

[val idxMax] = arraymax(r);
if lr(idxMax(1)) ~= expected_max_lag(1) ...
    || lc(idxMax(2)) ~= expected_max_lag(2) ...
    || lp(idxMax(3)) ~= expected_max_lag(3)
  warning('%s failed', strTestLabel);
  fprintf('Peak lag detected:  %d, %d, %d\n', ...
    lr(idxMax(1)), lc(idxMax(2)), lp(idxMax(3)));
  fprintf('Peak lag expected:  %d, %d, %d\n', ...
    expected_max_lag(1), expected_max_lag(2), expected_max_lag(3));
else
  fprintf('%s passed\n', strTestLabel)
end
