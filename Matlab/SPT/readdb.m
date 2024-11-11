function featureVector = readdb(filename, maxJoints)
if nargin < 2
  maxJoints = Inf;
end

[fid msg] = fopen(filename, 'r');

if fid == -1
  disp(msg);
  return;
end

%%
%%  Get the first line
%%
line = fgetl(fid);
nJoints = 0;
while line ~= -1 & nJoints < maxJoints
  nJoints = nJoints + 1;

  %%
  %%  Get the joint state
  %%
  [strState restOfLine] = strtok(line);
  state = eval(strState);

  %%
  %%  Parse the rest of the line getting the features
  %%
  features = [];
  [strFeature restOfLine] = strtok(restOfLine);

  while ~isempty(strFeature)
    [fnum value] = strtok(strFeature, ':');
    features = [features eval(value(2:end))];
    [strFeature restOfLine] = strtok(restOfLine);
  end
  
  %%
  %%  Add the state and features to the feature vector matrix
  %%
  featureVector(nJoints,:) = [state features];
  
  %%
  %%  Get the next line
  %%
  line = fgetl(fid);
end
