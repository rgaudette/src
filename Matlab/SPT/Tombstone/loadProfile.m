%loadProfile    Load in a profile vector from the 5DX
%
% comp = loadProfile(preString)
%
%  Status: functional
function comp = loadProfile(preString)

spine_profile = load([preString '_spine_profile.dat']);
nProfsPerChip = 4;

[nProfs nElem] = size(spine_profile);

nChips = nProfs / nProfsPerChip;

for i = 1:nChips
  name = input(['Enter the device name for ' int2str(i) ' device: '], 's');
  comp(i).Name = name;
  
  for j = 1:nProfsPerChip
    iProf = j + (i - 1) * nProfsPerChip;
    comp(i).Profile(j,:) = findNZData(spine_profile(iProf, :));
  end
end
  
function nzProf = findNZData(spine_profile)
nzIdx = find(spine_profile ~= 0);
idxStart = min(nzIdx);
idxStop = max(nzIdx);
nzProf = spine_profile(idxStart:idxStop);