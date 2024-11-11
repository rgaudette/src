%parseStalkModel   Parse a ATP synthase stalk model into a inital motive
%                  list head model and stalk centroid model.
%
%  [imodHead, imodCentroid, initMotiveList] = parseStalkModel(imodStalk, iRef)
function [imodHead, imodCentroid, initMotiveList] = ...
  parseStalkModel(imodStalk, iRef)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: parseStalkModel.m,v 1.10 2005/08/15 23:17:36 rickg Exp $\n');
end

% Get the stalk object from the Imod model
stalks = getObject(imodStalk, 1);
nStalks = getNContours(stalks);

% Get the reference vector
if iRef > 0
  ptsRef = imodPoints2Index(getPoints(stalks, iRef));
  vecRef = ptsRef(:,2) - ptsRef(:,1);
else
  vecRef = [
    0
    0
    1];
end

% Initialize the motive list
initMotiveList = zeros(20, nStalks);
initMotiveList(1,:) = 1;
initMotiveList(4,:) = 1:nStalks;
initMotiveList(5,:) = 1;

% Allocate the head point array
ptsHead = zeros(3, nStalks);
ptsCentroid = zeros(3, nStalks);

for iStalk = 1:nStalks
  % get the current stalk vector
  ptsStalk = imodPoints2Index(getPoints(stalks, iStalk));
  vecStalk = ptsStalk(:,2) - ptsStalk(:,1);

  % Find the euler angles necessary to rotate the reference to the current
  % stalk vector
  [phi theta psi] = findRotateVector(vecStalk, vecRef);

  % Fill in the initial motive list
  initMotiveList(17, iStalk) = phi;
  initMotiveList(19, iStalk) = theta;
  initMotiveList(18, iStalk) = psi;

  % Extract just the head point for the volume center model
  ptsHead(:, iStalk) = ptsStalk(:, 1);  
  
  % Find the centroid of the two points
  ptsCentroid(:, iStalk) = 0.5 * (ptsStalk(:, 1) + ptsStalk(:, 2)); 
end

% Create the head model
imodHead = appendObject(ImodModel, ...
  appendContour(ImodObject, ImodContour(ptsHead)));
imodHead = setMax(imodHead, findRange(imodHead));

% Create the centroid model
imodCentroid = appendObject(ImodModel, ...
  appendContour(ImodObject, ImodContour(ptsCentroid)));
imodCentroid = setMax(imodCentroid, findRange(imodCentroid));
