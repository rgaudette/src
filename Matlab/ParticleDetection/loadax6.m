% AX6 test script

% Load in the data if is is not already loaded

if exist('ax6', 'var') ~= 1
  ax6 = MRCImage('ax6flipped.byte')
end

ax6Model = ImodModel('ax6.mod');
ax6points = getPoints(ax6Model, 1, 1)';
ax6DyneinPos = getPoints(ax6Model, 1, 2)';

% Interpolate the data into a tube

% Extract the template for the cross correlation coefficient computation

