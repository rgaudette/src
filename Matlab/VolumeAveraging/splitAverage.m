%splitAverage   Compute an even and odd average from a motivelist

function splitAverage(fnVolume, fnModParticle, szVol, fnMotiveList, ...
  fnOutput, threshold)

global PRINT_ID
if PRINT_ID
    fprintf('$Id: splitAverage.m,v 1.5 2005/08/15 23:17:37 rickg Exp $\n');
end

% Open the MRCImage object and particle model
volume = MRCImage(fnVolume, 0);
modParticle = ImodModel(fnModParticle);

% Split the motive list into odd and even particles, first sorted by CCC
motiveList = loadMOTL(fnMotiveList);
[sortCCC idxReorder] = sort(motiveList(1, :), 'descend');
motiveList = motiveList(:, idxReorder);

oddMotiveList = motiveList(:,1:2:end);
evenMotiveList = motiveList(:,2:2:end);

[oddVolume oddNAvg oddThreshold oddSelected] = ...
  motlAverage3(volume, modParticle, szVol, oddMotiveList, threshold);
strThresh = sprintf('%7.6f', oddThreshold);
    strNAvg = sprintf('%03d', oddNAvg);
fnOdd = [fnOutput '_' strNAvg '_' strThresh '_odd.mrc']
save(MRCImage(oddVolume), fnOdd);

[evenVolume evenNAvg evenThreshold evenSelected] = ...
  motlAverage3(volume, modParticle, szVol, evenMotiveList, threshold);
strThresh = sprintf('%7.6f', evenThreshold);
    strNAvg = sprintf('%03d', evenNAvg);
fnEven = [fnOutput '_' strNAvg '_' strThresh '_even.mrc']
save(MRCImage(evenVolume), fnEven);
