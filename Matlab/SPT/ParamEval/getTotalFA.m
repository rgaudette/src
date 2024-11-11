%getTotalFA    Returns the number of false alarms in a totalCallArray
%                   given the component ID.
%
% calls = getTotalFA(callArray, compID)
%
function calls = getTotalFA(tca, compID)

idxComp = findCellArrayStr(tca.compID, compID);
if idxComp == 0
  warning(['Component: ' compID ' not found']);
  calls = [];
  return
end

nFOV = length(tca.FOVList);
nRes = length(tca.ResList);
nIC = length(tca.ICList);
nZ = length(tca.zHeight);

calls = zeros(nZ, nFOV, nRes, nIC);

for idxIC = 1:nIC
  for idxRes = 1:nRes
    for idxFOV = 1:nFOV
      for idxZ = 1:nZ
        if ~isempty(tca.count{idxComp, idxZ, idxFOV, idxRes, idxIC})
          calls(idxZ, idxFOV, idxRes, idxIC) = ...
              sum(tca.count{idxComp, idxZ, idxFOV, idxRes, idxIC});
        end
      end
    end
  end
end

  
