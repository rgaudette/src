%cmpAvgVsPin    Compare average HW ratio averages
%
%  Status: under development
function cmpAvgVsPin(hwratio)

joint1 = [1:4];
joint1Pin = [1 2];
joint1Body = [3 4];

joint2 = [5:8];
joint2Pin = [7 8];
joint2Body = [5 6];

%%
%%  Compute the average of all four joint measurements for each
%%  joint
%%
pin1 = hwratio(:, joint1);
pin1mean = mean(pin1')';

pin2 = hwratio(:, joint2);
pin2mean = mean(pin2')';

all4mean = [pin1mean pin2mean]

%%
%%  Compute the average over just the pin spine
%%
joint1PinSpineMean = mean(hwratio(:, joint1Pin)')';
joint2PinSpineMean = mean(hwratio(:, joint2Pin)')';

pinSpineMean = [joint1PinSpineMean joint2PSpineMean]

%%
%%  Compute the average over just the body spine
%%
error('This code needs to be updated')
joint1BSpine = hwratio(:,1:2);
joint1BSpineMean = mean(joint1BSpine')';

pin2BSpine = hwratio(:,5:6);
pin2BSpineMean = mean(pin2BSpine')';

bodySpineMean = [joint1BSpineMean pin2BSpineMean]

%%
%%  Compute the ratio of the of the average of the two pin spine
%%  hw ratios
%%  argument - they should be similar ie close to 1
%%

pinSpineRatio = joint1PSpineMean ./ pin2PSpineMean