%calcMinNormMeanDiff  Calculatue the minimum normalized spine H-W difference
%
%   minNormMeanDiff = calcMinNormMeanDiff(HWRatio)
%
%   Status: functional

function minNormMeanDiff = calcMinNormMeanDiff(HWRatio)

j1Pin = [1 2];
j1Body = [3 4];
j2Body = [5 6];
j2Pin = [7 8];

%%
%%  Calculate the means for each joint
%%
meanJoint1PinHWRatio = mean(HWRatio(:, j1Pin)')';
meanJoint1BodyHWRatio = mean(HWRatio(:, j1Body)')';
meanJoint2BodyHWRatio = mean(HWRatio(:, j2Body)')';
meanJoint2PinHWRatio = mean(HWRatio(:, j2Pin)')';

diffPin = meanJoint1PinHWRatio - meanJoint2PinHWRatio;
diffBody = meanJoint1BodyHWRatio - meanJoint2BodyHWRatio;

%%
%%  Compare joint 1 values to joint 2 means
%%
normDiffJoint1Pin = diffPin ./ meanJoint2PinHWRatio;
normDiffJoint1Body = diffBody ./ meanJoint2BodyHWRatio;   
minNormMeanDiffJoint1 = min([normDiffJoint1Pin normDiffJoint1Body]')';

%%
%%  Compare joint 2 values to joint 1 means
%%
normDiffJoint2Pin = - diffPin ./ meanJoint1PinHWRatio;
normDiffJoint2Body = - diffBody ./ meanJoint1BodyHWRatio;
minNormMeanDiffJoint2 = min([normDiffJoint2Pin normDiffJoint2Body]')';

%%
%%  Insert the joint minimums into the result
%%
minNormMeanDiff = [minNormMeanDiffJoint1 minNormMeanDiffJoint2];
