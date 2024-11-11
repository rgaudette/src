%calcMinNormDiff  Calculatue the minimum normalized spine H-W difference
%
%   minNormDiff = calcMinNormDiff(HWRatio)
%
%   Status: functional

function minNormDiff = calcMinNormDiff(HWRatio)

j1Pin = [1 2];
j1Body = [3 4];
j2Body = [5 6];
j2Pin = [7 8];

%%
%%  Calculate joint 2 means
%%
meanJoint2BodyHWRatio = mean(HWRatio(:, j2Body)')';
meanJoint2PinHWRatio = mean(HWRatio(:, j2Pin)')';

%%
%%  Compare joint 1 values to joint 2 means
%%
diffJoint1Pin = HWRatio(:, j1Pin) - meanJoint2PinHWRatio * [1 1];
normDiffJoint1Pin = diffJoint1Pin ./ (meanJoint2PinHWRatio * [1 1]);
   
diffJoint1Body = HWRatio(:, j1Body) - meanJoint2BodyHWRatio * [1 1];
normDiffJoint1Body = diffJoint1Body ./ (meanJoint2BodyHWRatio * [1 1]);

minNormDiffJoint1 = min([normDiffJoint1Pin normDiffJoint1Body]')';

%%
%%  Calculate pin 2 means
%%
meanJoint1PinHWRatio = mean(HWRatio(:, j1Pin)')';
meanJoint1BodyHWRatio = mean(HWRatio(:, j1Body)')';

%%
%%  Compare joint 2 values to joint 1 means
%%
diffJoint2Pin = HWRatio(:, j2Pin) - meanJoint1PinHWRatio * [1 1];
normDiffJoint2Pin = diffJoint2Pin ./ (meanJoint1PinHWRatio * [1 1]);
   
diffJoint2Body = HWRatio(:, j2Body) - meanJoint1BodyHWRatio * [1 1];
normDiffJoint2Body = diffJoint2Body ./ (meanJoint1BodyHWRatio * [1 1]);

minNormDiffJoint2 = min([normDiffJoint2Pin normDiffJoint2Body]')';


minNormDiff = [minNormDiffJoint1 minNormDiffJoint2];
