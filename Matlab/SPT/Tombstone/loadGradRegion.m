%loadGradRegion Load in the gradient region from the chip algorithm
%
%  jointArray = loadGradRegion(filename)
%
%  Status: functional

function joint = loadGradRegion(filename)

%%
%%  Load in the file
%%
rawData = load(filename);

[nJoints] = size(rawData, 1);

for iJoint = 1:nJoints
  joint(iJoint).image = reshape(rawData(iJoint,3:end), ...
                                rawData(iJoint,1), rawData(iJoint,2));
end